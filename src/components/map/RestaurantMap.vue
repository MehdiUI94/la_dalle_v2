<template>
  <div class="restaurant-map">
    <div v-if="isLoading" class="loading-overlay">
      <div class="loading-spinner"></div>
      <p>Chargement de la carte...</p>
    </div>
    <div v-if="error" class="error-message">
      {{ error }}
    </div>
    <div ref="mapContainer" class="map-container"></div>
    <div v-if="!isLoading && !error" class="map-info">
      <p class="restaurant-count">{{ restaurantCount }} restaurant{{ restaurantCount > 1 ? 's' : '' }} sur la carte</p>
    </div>
    
    <!-- Modal de notation -->
    <RestaurantRatingModal
      v-model:is-open="ratingModalOpen"
      :restaurant-id="selectedRestaurantId"
      :restaurant-name="selectedRestaurantName"
      @rating-updated="handleRatingUpdated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import L from 'leaflet'
import { supabase } from '@/lib/supabaseClient'
import { useLocationStore } from '@/stores/location'
import { useGeolocation } from '@/composables/useGeolocation'
import { useUserStore } from '@/stores/user'
import { useFavorites } from '@/composables/useFavorites'
import { useRestaurantRatings } from '@/composables/useRestaurantRatings'
import RestaurantRatingModal from './RestaurantRatingModal.vue'
import type { Database } from '@/types/database'
import type { FilterOptions } from './FilterBar.vue'
import 'leaflet/dist/leaflet.css'

// Déclarer la fonction globale pour TypeScript
declare global {
  interface Window {
    openRatingModal: (restaurantId: string, restaurantName: string) => void
  }
}

type Restaurant = Database['public']['Tables']['restaurants']['Row']
type Deal = Database['public']['Tables']['deals']['Row']

interface RestaurantWithDeals extends Restaurant {
  deals?: Deal[]
  distance?: number // Distance en km depuis la position du client
  rating?: number // Note sur 5 (fictif pour l'instant)
  foodType?: string | null // Type de nourriture (fictif pour l'instant)
  diet?: string[] | null // Régimes alimentaires (fictif pour l'instant)
}

interface Props {
  filters?: FilterOptions
}

const props = withDefaults(defineProps<Props>(), {
  filters: () => ({
    minRating: null,
    maxDistance: null,
    hasPromos: false,
    favoritesOnly: false,
    foodType: null,
    diet: null
  })
})

const mapContainer = ref<HTMLElement | null>(null)
const isLoading = ref(true)
const error = ref<string | null>(null)
const restaurantCount = ref(0)
const isRealtimeConnected = ref(false)
const ratingModalOpen = ref(false)
const selectedRestaurantId = ref<string | null>(null)
const selectedRestaurantName = ref('')

const locationStore = useLocationStore()
const userStore = useUserStore()
const { calculateDistance, filterByRadius } = useGeolocation()
const { loadFavorites, hasFavoriteDeals, getFavoriteDealIds } = useFavorites()
const { getRestaurantsAverageRatings } = useRestaurantRatings()

let map: L.Map | null = null
let markers: Map<string, L.Marker> = new Map()
let userMarker: L.Marker | null = null
let realtimeChannel: ReturnType<typeof supabase.channel> | null = null

// Centre par défaut : Paris
const defaultCenter: [number, number] = [48.8566, 2.3522]
const RADIUS_KM = 10 // Rayon de recherche en km

// Générer des données fictives pour les restaurants (pour foodType et diet uniquement)
// Utilise l'ID du restaurant pour générer des données déterministes
const generateMockData = (restaurant: Restaurant): Partial<RestaurantWithDeals> => {
  // Utiliser l'ID comme seed pour générer des données déterministes
  const seed = restaurant.id.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0)
  
  // Types de nourriture basés sur le seed
  const foodTypes = ['pizza', 'burger', 'sushi', 'italien', 'asiatique', 'francais', 'mexicain', 'vegetarien', 'vegan']
  const foodType = foodTypes[seed % foodTypes.length]
  
  // Régimes possibles basés sur le seed
  const diets: string[] = []
  if (seed % 3 === 0) diets.push('vegetarien')
  if (seed % 4 === 0) diets.push('vegan')
  if (seed % 5 === 0) diets.push('sans-gluten')
  
  return {
    foodType,
    diet: diets.length > 0 ? diets : null
  }
}

// Appliquer les filtres aux restaurants
const applyFilters = (restaurants: RestaurantWithDeals[]): RestaurantWithDeals[] => {
  let filtered = [...restaurants]
  const filters = props.filters

  // Filtrer par note minimum
  if (filters.minRating !== null) {
    filtered = filtered.filter(r => (r.rating || 0) >= filters.minRating!)
  }

  // Filtrer par distance maximum
  if (filters.maxDistance !== null && userStore.user?.role === 'etudiant') {
    filtered = filtered.filter(r => {
      if (r.distance === undefined) return false
      return r.distance <= filters.maxDistance!
    })
  }

  // Filtrer par restaurants avec promos
  if (filters.hasPromos) {
    filtered = filtered.filter(r => (r.deals || []).length > 0)
  }

  // Filtrer par favoris
  if (filters.favoritesOnly && userStore.user?.role === 'etudiant') {
    const favoriteDealIds = getFavoriteDealIds()
    filtered = filtered.filter(r => {
      const dealIds = (r.deals || []).map(d => d.id)
      // Vérifier si au moins un deal du restaurant est en favori
      return dealIds.some(dealId => favoriteDealIds.includes(dealId))
    })
  }

  // Filtrer par type de nourriture
  if (filters.foodType !== null) {
    filtered = filtered.filter(r => r.foodType === filters.foodType)
  }

  // Filtrer par régime
  if (filters.diet !== null) {
    filtered = filtered.filter(r => {
      if (!r.diet || r.diet.length === 0) return false
      return r.diet.includes(filters.diet!)
    })
  }

  return filtered
}

// Récupérer les restaurants avec leurs deals actifs et filtrer par distance
const fetchRestaurants = async (): Promise<RestaurantWithDeals[]> => {
  try {
    // Charger les favoris si l'utilisateur est un client
    if (userStore.user?.role === 'etudiant' && userStore.user?.id) {
      await loadFavorites(userStore.user.id)
    }

    // Récupérer tous les restaurants avec coordonnées
    const { data: restaurants, error: restaurantsError } = await supabase
      .from('restaurants')
      .select(`
        *,
        deals (
          id,
          title,
          description,
          category,
          is_active,
          created_at
        )
      `)
      .not('lat', 'is', null)
      .not('lng', 'is', null)

    if (restaurantsError) throw restaurantsError

    // Filtrer pour ne garder que les deals actifs et ajouter les données fictives
    let restaurantsWithActiveDeals = (restaurants || []).map(restaurant => {
      const deals = (restaurant.deals || []).filter((deal: Deal) => deal.is_active)
      const mockData = generateMockData(restaurant)
      return {
        ...restaurant,
        deals,
        ...mockData
      } as RestaurantWithDeals
    })

    // Récupérer les notes moyennes des restaurants (si disponibles)
    try {
      const restaurantIds = restaurantsWithActiveDeals.map(r => r.id)
      if (restaurantIds.length > 0) {
        const ratingsMap = await getRestaurantsAverageRatings(restaurantIds)
        
        // Ajouter les notes aux restaurants seulement si ratingsMap est valide et la note n'est pas null
        if (ratingsMap && ratingsMap instanceof Map) {
          restaurantsWithActiveDeals = restaurantsWithActiveDeals.map(restaurant => {
            const rating = ratingsMap.get(restaurant.id)
            return {
              ...restaurant,
              rating: rating !== null && rating !== undefined ? rating : undefined
            }
          })
        }
      }
    } catch (err) {
      console.warn('Impossible de récupérer les notes, continuation sans notes:', err)
      // Continuer sans les notes en cas d'erreur
    }

    // Si l'utilisateur est un client, filtrer par distance
    if (userStore.user?.role === 'etudiant') {
      const currentCoords = locationStore.getCurrentCoordinates()
      if (currentCoords) {
        // Utiliser le filtre de distance si défini, sinon 10km par défaut
        const maxDistance = props.filters.maxDistance || RADIUS_KM
        
        // Filtrer les restaurants dans le rayon défini
        restaurantsWithActiveDeals = filterByRadius(
          restaurantsWithActiveDeals,
          currentCoords.lat,
          currentCoords.lng,
          maxDistance
        ) as RestaurantWithDeals[]

        // Calculer la distance pour chaque restaurant
        restaurantsWithActiveDeals = restaurantsWithActiveDeals.map(restaurant => ({
          ...restaurant,
          distance: calculateDistance(
            currentCoords.lat,
            currentCoords.lng,
            restaurant.lat!,
            restaurant.lng!
          )
        }))
      }
    }

    // Appliquer tous les filtres
    restaurantsWithActiveDeals = applyFilters(restaurantsWithActiveDeals)

    return restaurantsWithActiveDeals
  } catch (err: any) {
    console.error('Erreur lors de la récupération des restaurants:', err)
    throw err
  }
}

// Ouvrir la modal de notation
const openRatingModal = (restaurantId: string, restaurantName: string) => {
  selectedRestaurantId.value = restaurantId
  selectedRestaurantName.value = restaurantName
  ratingModalOpen.value = true
}

// Gérer la mise à jour de la note
const handleRatingUpdated = async () => {
  // Recharger les restaurants pour mettre à jour les notes
  if (map) {
    await initMap()
  }
}

// Créer le contenu du popup pour un restaurant
const createPopupContent = (restaurant: RestaurantWithDeals): string => {
  const deals = restaurant.deals || []
  const dealsHtml = deals.length > 0
    ? `<div class="popup-deals">
        <h4>Deals actifs :</h4>
        <ul>
          ${deals.map(deal => `<li><strong>${deal.title}</strong>${deal.description ? ` - ${deal.description}` : ''}</li>`).join('')}
        </ul>
      </div>`
    : '<p>Aucun deal actif pour le moment</p>'

  const distanceHtml = restaurant.distance !== undefined
    ? `<p><strong>📏</strong> ${restaurant.distance.toFixed(1)} km</p>`
    : ''

  // Afficher la note uniquement si elle existe (au moins une note enregistrée)
  const ratingHtml = restaurant.rating !== undefined && restaurant.rating !== null
    ? `<p><strong>⭐</strong> ${restaurant.rating.toFixed(1)}/5</p>`
    : ''

  // Bouton pour noter (uniquement pour les clients)
  const rateButtonHtml = userStore.user?.role === 'etudiant'
    ? `<button class="rate-button" onclick="window.openRatingModal('${restaurant.id}', '${restaurant.name.replace(/'/g, "\\'")}')">⭐ Noter ce restaurant</button>`
    : ''

  return `
    <div class="popup-content">
      <h3>${restaurant.name}</h3>
      ${restaurant.address ? `<p><strong>📍</strong> ${restaurant.address}</p>` : ''}
      ${distanceHtml}
      ${ratingHtml}
      ${restaurant.phone ? `<p><strong>📞</strong> ${restaurant.phone}</p>` : ''}
      ${restaurant.description ? `<p>${restaurant.description}</p>` : ''}
      ${dealsHtml}
      ${rateButtonHtml}
    </div>
  `
}

// Créer une icône personnalisée pour les marqueurs de restaurants
const createCustomIcon = () => {
  return L.divIcon({
    className: 'custom-marker',
    html: `
      <div style="
        background-color: #EF4444;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: 3px solid white;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
      ">
        🍽️
      </div>
    `,
    iconSize: [40, 40],
    iconAnchor: [20, 40],
    popupAnchor: [0, -40]
  })
}

// Créer une icône personnalisée pour le marqueur de l'utilisateur
const createUserIcon = () => {
  return L.divIcon({
    className: 'user-marker',
    html: `
      <div style="
        background-color: var(--primary);
        width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 3px solid white;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
      ">
        👤
      </div>
    `,
    iconSize: [30, 30],
    iconAnchor: [15, 30],
    popupAnchor: [0, -30]
  })
}

// Ajouter un marqueur sur la carte
const addMarker = (restaurant: RestaurantWithDeals) => {
  if (!map || !restaurant.lat || !restaurant.lng) return

  const marker = L.marker([restaurant.lat, restaurant.lng], {
    icon: createCustomIcon()
  })

  const popupContent = createPopupContent(restaurant)
  
  marker.bindPopup(popupContent, {
    maxWidth: 300,
    className: 'custom-popup'
  })

  // Ajouter un gestionnaire d'événements pour le popup après qu'il soit ajouté à la carte
  marker.on('popupopen', () => {
    // Exposer la fonction openRatingModal globalement pour qu'elle soit accessible depuis le HTML du popup
    ;(window as any).openRatingModal = (restaurantId: string, restaurantName: string) => {
      openRatingModal(restaurantId, restaurantName)
    }
  })

  marker.addTo(map)
  markers.set(restaurant.id, marker)
}

// Supprimer un marqueur
const removeMarker = (restaurantId: string) => {
  const marker = markers.get(restaurantId)
  if (marker && map) {
    map.removeLayer(marker)
    markers.delete(restaurantId)
  }
}

// Mettre à jour un marqueur
const updateMarker = (restaurant: RestaurantWithDeals) => {
  removeMarker(restaurant.id)
  addMarker(restaurant)
}

// Ajouter le marqueur de l'utilisateur
const addUserMarker = (lat: number, lng: number) => {
  if (!map) return

  // Supprimer l'ancien marqueur s'il existe
  if (userMarker) {
    map.removeLayer(userMarker)
  }

  userMarker = L.marker([lat, lng], {
    icon: createUserIcon(),
    zIndexOffset: 1000 // Au-dessus des autres marqueurs
  })

  userMarker.bindPopup('Votre position', {
    className: 'user-popup'
  })

  userMarker.addTo(map)
}

// Initialiser la carte Leaflet
const initMap = async () => {
  try {
    isLoading.value = true
    error.value = null

    if (!mapContainer.value) {
      throw new Error('Conteneur de carte non trouvé')
    }

    // Attendre que le conteneur soit complètement rendu et ait une hauteur
    await new Promise(resolve => setTimeout(resolve, 100))
    
    // Vérifier que le conteneur a une hauteur
    if (mapContainer.value.offsetHeight === 0) {
      console.warn('Le conteneur de carte n\'a pas de hauteur, nouvelle tentative...')
      await new Promise(resolve => setTimeout(resolve, 200))
    }

    // Obtenir la position du client (temporaire ou par défaut)
    let centerLat = defaultCenter[0]
    let centerLng = defaultCenter[1]
    let zoom = 13

    if (userStore.user?.role === 'etudiant') {
      const currentCoords = locationStore.getCurrentCoordinates()
      if (currentCoords) {
        centerLat = currentCoords.lat
        centerLng = currentCoords.lng
        zoom = 14 // Zoom plus proche pour la position de l'utilisateur
      }
    }

    // Charger les restaurants (filtrés par distance si client)
    let restaurants: RestaurantWithDeals[] = []
    try {
      restaurants = await fetchRestaurants()
    } catch (fetchError: unknown) {
      console.error('Erreur lors du chargement des restaurants:', fetchError)
      const err = fetchError instanceof Error ? fetchError : new Error('Erreur lors du chargement des restaurants')
      error.value = err.message
      isLoading.value = false
      return
    }
    
    restaurantCount.value = restaurants.length

    // Si la carte existe déjà, la détruire avant de la recréer
    if (map) {
      map.remove()
      map = null
    }
    markers.clear()
    userMarker = null

    // Créer la carte centrée sur la position du client
    map = L.map(mapContainer.value, {
      center: [centerLat, centerLng],
      zoom: zoom,
      zoomControl: true,
      attributionControl: true
    })

    // Forcer le recalcul de la taille de la carte après un court délai
    setTimeout(() => {
      if (map) {
        map.invalidateSize()
      }
    }, 100)

    // Ajouter la couche de tuiles OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 19
    }).addTo(map)

    // Ajouter le marqueur de l'utilisateur si c'est un client
    if (userStore.user?.role === 'etudiant' && locationStore.getCurrentCoordinates()) {
      const coords = locationStore.getCurrentCoordinates()!
      addUserMarker(coords.lat, coords.lng)
    }

    // Ajouter les marqueurs des restaurants
    const markerGroup = L.featureGroup()
    restaurants.forEach((restaurant) => {
      addMarker(restaurant)
      const marker = markers.get(restaurant.id)
      if (marker) {
        markerGroup.addLayer(marker)
      }
    })

    // Ajuster la vue pour afficher tous les marqueurs (utilisateur + restaurants)
    if (userMarker) {
      markerGroup.addLayer(userMarker)
    }

    if (markers.size > 0 || userMarker) {
      map.fitBounds(markerGroup.getBounds().pad(0.1), {
        maxZoom: 16
      })
    } else {
      map.setView([centerLat, centerLng], zoom)
    }

    isLoading.value = false
  } catch (err: unknown) {
    console.error('Erreur lors de l\'initialisation de la carte:', err)
    const error = err instanceof Error ? err : new Error('Erreur lors du chargement de la carte')
    error.value = error.message
    isLoading.value = false
  }
}

// Recharger la carte quand la localisation change
watch(
  () => [locationStore.temporaryLocation, locationStore.temporaryCoordinates, locationStore.defaultCoordinates],
  async (newValues, oldValues) => {
    // Éviter les rechargements inutiles
    if (map && userStore.user?.role === 'etudiant' && JSON.stringify(newValues) !== JSON.stringify(oldValues)) {
      await initMap()
    }
  },
  { deep: true }
)

// Recharger la carte quand les filtres changent
watch(
  () => props.filters,
  async () => {
    if (map) {
      await initMap()
    }
  },
  { deep: true }
)

// Configurer Supabase Realtime pour écouter les changements
const setupRealtime = () => {
  // Écouter les changements sur la table restaurants
  realtimeChannel = supabase
    .channel('restaurants-realtime')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'restaurants',
        filter: 'lat=not.is.null'
      },
      async (payload) => {
        console.log('🔄 Changement détecté sur restaurants:', payload.eventType, payload.new || payload.old)

        if (payload.eventType === 'INSERT' && payload.new) {
          // Nouveau restaurant ajouté
          const restaurant = payload.new as Restaurant
          if (restaurant.lat && restaurant.lng) {
            // Récupérer les deals actifs pour ce restaurant
            const { data: deals } = await supabase
              .from('deals')
              .select('*')
              .eq('restaurant_id', restaurant.id)
              .eq('is_active', true)

            const mockData = generateMockData(restaurant)
            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: deals || [],
              ...mockData
            }

            // Récupérer la note moyenne du restaurant (si disponible)
            try {
              const rating = await getRestaurantsAverageRatings([restaurant.id])
              restaurantWithDeals.rating = rating.get(restaurant.id) || undefined
            } catch (err) {
              console.warn('Impossible de récupérer la note:', err)
            }

            // Calculer la distance si c'est un client
            if (userStore.user?.role === 'etudiant') {
              const currentCoords = locationStore.getCurrentCoordinates()
              if (currentCoords) {
                restaurantWithDeals.distance = calculateDistance(
                  currentCoords.lat,
                  currentCoords.lng,
                  restaurant.lat!,
                  restaurant.lng!
                )
              }
            }

            // Appliquer les filtres avant d'ajouter le marqueur
            const filtered = applyFilters([restaurantWithDeals])
            if (filtered.length > 0) {
              addMarker(restaurantWithDeals)
              restaurantCount.value = markers.size

              // Recentrer la carte si c'est le premier marqueur
              if (markers.size === 1 && map) {
                map.setView([restaurant.lat, restaurant.lng], 13)
              } else if (map && markers.size > 1) {
                // Ajuster la vue pour inclure le nouveau marqueur
                const bounds = L.latLngBounds(
                  Array.from(markers.values()).map(m => m.getLatLng())
                )
                map.fitBounds(bounds.pad(0.1), { maxZoom: 16 })
              }
            }
          }
        } else if (payload.eventType === 'UPDATE' && payload.new) {
          // Restaurant modifié
          const restaurant = payload.new as Restaurant
          if (restaurant.lat && restaurant.lng) {
            // Récupérer les deals actifs
            const { data: deals } = await supabase
              .from('deals')
              .select('*')
              .eq('restaurant_id', restaurant.id)
              .eq('is_active', true)

            const mockData = generateMockData(restaurant)
            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: deals || [],
              ...mockData
            }

            // Récupérer la note moyenne du restaurant (si disponible)
            try {
              const rating = await getRestaurantsAverageRatings([restaurant.id])
              restaurantWithDeals.rating = rating.get(restaurant.id) || undefined
            } catch (err) {
              console.warn('Impossible de récupérer la note:', err)
            }

            // Calculer la distance si c'est un client
            if (userStore.user?.role === 'etudiant') {
              const currentCoords = locationStore.getCurrentCoordinates()
              if (currentCoords) {
                restaurantWithDeals.distance = calculateDistance(
                  currentCoords.lat,
                  currentCoords.lng,
                  restaurant.lat!,
                  restaurant.lng!
                )
              }
            }

            // Appliquer les filtres avant de mettre à jour le marqueur
            const filtered = applyFilters([restaurantWithDeals])
            if (filtered.length > 0) {
              updateMarker(restaurantWithDeals)
            } else {
              // Si le restaurant ne correspond plus aux filtres, le retirer
              removeMarker(restaurant.id)
            }
          } else {
            // Si les coordonnées sont supprimées, retirer le marqueur
            removeMarker(restaurant.id)
            restaurantCount.value = markers.size
          }
        } else if (payload.eventType === 'DELETE' && payload.old) {
          // Restaurant supprimé
          const restaurant = payload.old as Restaurant
          removeMarker(restaurant.id)
          restaurantCount.value = markers.size
        }
      }
    )
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'deals'
      },
      async (payload) => {
        console.log('🔄 Changement détecté sur deals:', payload.eventType)

        // Quand un deal change, mettre à jour uniquement le restaurant concerné
        if (payload.new) {
          const deal = payload.new as Deal
          const restaurantId = deal.restaurant_id

          // Récupérer le restaurant avec ses deals mis à jour
          const { data: restaurant, error } = await supabase
            .from('restaurants')
            .select(`
              *,
              deals (
                id,
                title,
                description,
                category,
                is_active,
                created_at
              )
            `)
            .eq('id', restaurantId)
            .single()

          if (!error && restaurant && restaurant.lat && restaurant.lng) {
            const mockData = generateMockData(restaurant)
            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: (restaurant.deals || []).filter((d: Deal) => d.is_active),
              ...mockData
            }

            // Récupérer la note moyenne du restaurant (si disponible)
            try {
              const rating = await getRestaurantsAverageRatings([restaurant.id])
              restaurantWithDeals.rating = rating.get(restaurant.id) || undefined
            } catch (err) {
              console.warn('Impossible de récupérer la note:', err)
            }

            // Calculer la distance si c'est un client
            if (userStore.user?.role === 'etudiant') {
              const currentCoords = locationStore.getCurrentCoordinates()
              if (currentCoords) {
                restaurantWithDeals.distance = calculateDistance(
                  currentCoords.lat,
                  currentCoords.lng,
                  restaurant.lat!,
                  restaurant.lng!
                )
              }
            }

            // Appliquer les filtres
            const filtered = applyFilters([restaurantWithDeals])
            if (filtered.length > 0) {
              // Mettre à jour le marqueur
              if (markers.has(restaurantId)) {
                updateMarker(restaurantWithDeals)
              } else {
                // Si le restaurant n'était pas sur la carte, l'ajouter
                addMarker(restaurantWithDeals)
                restaurantCount.value = markers.size
              }
            } else if (markers.has(restaurantId)) {
              // Si le restaurant ne correspond plus aux filtres, le retirer
              removeMarker(restaurantId)
              restaurantCount.value = markers.size
            }
          }
        } else if (payload.old) {
          // Si un deal est supprimé, mettre à jour le restaurant
          const deal = payload.old as Deal
          const restaurantId = deal.restaurant_id

          if (markers.has(restaurantId)) {
            const { data: restaurant, error } = await supabase
              .from('restaurants')
              .select(`
                *,
                deals (
                  id,
                  title,
                  description,
                  category,
                  is_active,
                  created_at
                )
              `)
              .eq('id', restaurantId)
              .single()

            if (!error && restaurant && restaurant.lat && restaurant.lng) {
              const mockData = generateMockData(restaurant)
              const restaurantWithDeals: RestaurantWithDeals = {
                ...restaurant,
                deals: (restaurant.deals || []).filter((d: Deal) => d.is_active),
                ...mockData
              }

              // Récupérer la note moyenne du restaurant (si disponible)
              try {
                const rating = await getRestaurantsAverageRatings([restaurant.id])
                restaurantWithDeals.rating = rating.get(restaurant.id) || undefined
              } catch (err) {
                console.warn('Impossible de récupérer la note:', err)
              }

              // Calculer la distance si c'est un client
              if (userStore.user?.role === 'etudiant') {
                const currentCoords = locationStore.getCurrentCoordinates()
                if (currentCoords) {
                  restaurantWithDeals.distance = calculateDistance(
                    currentCoords.lat,
                    currentCoords.lng,
                    restaurant.lat!,
                    restaurant.lng!
                  )
                }
              }

              // Appliquer les filtres
              const filtered = applyFilters([restaurantWithDeals])
              if (filtered.length > 0) {
                updateMarker(restaurantWithDeals)
              } else {
                // Si le restaurant ne correspond plus aux filtres, le retirer
                removeMarker(restaurantId)
                restaurantCount.value = markers.size
              }
            }
          }
        }
      }
    )
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'restaurant_ratings'
      },
      async (payload) => {
        console.log('🔄 Changement détecté sur restaurant_ratings:', payload.eventType)

        // Quand une note change, mettre à jour le restaurant concerné
        if (payload.new) {
          const rating = payload.new as { restaurant_id: string }
          const restaurantId = rating.restaurant_id

          if (markers.has(restaurantId)) {
            // Récupérer le restaurant avec ses données mises à jour
            const { data: restaurant, error } = await supabase
              .from('restaurants')
              .select(`
                *,
                deals (
                  id,
                  title,
                  description,
                  category,
                  is_active,
                  created_at
                )
              `)
              .eq('id', restaurantId)
              .single()

            if (!error && restaurant && restaurant.lat && restaurant.lng) {
              const mockData = generateMockData(restaurant)
              const restaurantWithDeals: RestaurantWithDeals = {
                ...restaurant,
                deals: (restaurant.deals || []).filter((d: Deal) => d.is_active),
                ...mockData
              }

              // Récupérer la note moyenne mise à jour (si disponible)
              try {
                const ratings = await getRestaurantsAverageRatings([restaurant.id])
                restaurantWithDeals.rating = ratings.get(restaurant.id) || undefined
              } catch (err) {
                console.warn('Impossible de récupérer la note:', err)
              }

              // Calculer la distance si c'est un client
              if (userStore.user?.role === 'etudiant') {
                const currentCoords = locationStore.getCurrentCoordinates()
                if (currentCoords) {
                  restaurantWithDeals.distance = calculateDistance(
                    currentCoords.lat,
                    currentCoords.lng,
                    restaurant.lat!,
                    restaurant.lng!
                  )
                }
              }

              // Appliquer les filtres
              const filtered = applyFilters([restaurantWithDeals])
              if (filtered.length > 0) {
                updateMarker(restaurantWithDeals)
              } else {
                removeMarker(restaurantId)
                restaurantCount.value = markers.size
              }
            }
          }
        }
      }
    )
    .subscribe((status) => {
      console.log('📡 Statut Realtime:', status)
      isRealtimeConnected.value = status === 'SUBSCRIBED'
    })
}

onMounted(async () => {
  await initMap()
  setupRealtime()
})

onUnmounted(() => {
  // Nettoyer les ressources
  if (realtimeChannel) {
    supabase.removeChannel(realtimeChannel)
    realtimeChannel = null
  }

  if (userMarker && map) {
    map.removeLayer(userMarker)
    userMarker = null
  }

  if (map) {
    map.remove()
    map = null
  }

  markers.clear()
})
</script>

<style scoped>
.restaurant-map {
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 500px;
  flex: 1;
  display: flex;
  flex-direction: column;
  z-index: 1;
  margin: 0 0;
}

.map-container {
  width: 100%;
  height: 100%;
  flex: 1;
  min-height: 500px;
  border-radius: 1rem;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5px);
  z-index: 50;
  color: white;
  border-radius: 1rem;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-message {
  padding: 1rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  border-radius: 0.5rem;
  color: #ffcccc;
  margin-bottom: 1rem;
}

.map-info {
  margin-top: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
  color: white;
  font-size: 0.9rem;
}

.restaurant-count {
  font-weight: 600;
}

</style>

<style>
/* Styles globaux pour Leaflet */
.custom-marker {
  background: transparent !important;
  border: none !important;
}

.custom-popup {
  font-family: 'Inter', sans-serif;
}

/* S'assurer que les éléments Leaflet ne débordent pas sur la navbar */
.leaflet-container {
  z-index: 1 !important;
}

.leaflet-top,
.leaflet-bottom {
  z-index: 10 !important;
}

.leaflet-control {
  z-index: 10 !important;
}

.leaflet-popup {
  z-index: 20 !important;
}

.leaflet-pane {
  z-index: 1 !important;
}

.leaflet-map-pane {
  z-index: 1 !important;
}

.leaflet-tile-pane {
  z-index: 1 !important;
}

.leaflet-overlay-pane {
  z-index: 2 !important;
}

.leaflet-shadow-pane {
  z-index: 3 !important;
}

.leaflet-marker-pane {
  z-index: 4 !important;
}

.leaflet-tooltip-pane {
  z-index: 5 !important;
}

.leaflet-popup-pane {
  z-index: 6 !important;
}

.popup-content h3 {
  margin: 0 0 0.5rem 0;
  color: #1f2937;
  font-size: 1.1rem;
}

.popup-content p {
  margin: 0.25rem 0;
  color: #4b5563;
  font-size: 0.9rem;
}

.popup-deals {
  margin-top: 0.75rem;
  padding-top: 0.75rem;
  border-top: 1px solid #e5e7eb;
}

.popup-deals h4 {
  margin: 0 0 0.5rem 0;
  color: #1f2937;
  font-size: 0.95rem;
  font-weight: 600;
}

.popup-deals ul {
  margin: 0;
  padding-left: 1.25rem;
  color: #4b5563;
  font-size: 0.875rem;
}

.popup-deals li {
  margin: 0.25rem 0;
}

.rate-button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  width: 100%;
}

.rate-button:hover {
  background: #5568d3;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.leaflet-popup-content-wrapper {
  border-radius: 0.5rem;
}

.leaflet-popup-tip {
  background: white;
}

.user-popup {
  font-weight: 600;
  color: var(--primary);
}
</style>

