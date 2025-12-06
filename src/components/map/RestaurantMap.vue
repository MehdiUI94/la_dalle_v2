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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import L from 'leaflet'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'
import 'leaflet/dist/leaflet.css'

type Restaurant = Database['public']['Tables']['restaurants']['Row']
type Deal = Database['public']['Tables']['deals']['Row']

interface RestaurantWithDeals extends Restaurant {
  deals?: Deal[]
}

const mapContainer = ref<HTMLElement | null>(null)
const isLoading = ref(true)
const error = ref<string | null>(null)
const restaurantCount = ref(0)
const isRealtimeConnected = ref(false)

let map: L.Map | null = null
let markers: Map<string, L.Marker> = new Map()
let realtimeChannel: ReturnType<typeof supabase.channel> | null = null

// Centre par défaut : Paris
const defaultCenter: [number, number] = [48.8566, 2.3522]

// Récupérer les restaurants avec leurs deals actifs
const fetchRestaurants = async (): Promise<RestaurantWithDeals[]> => {
  try {
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

    // Filtrer pour ne garder que les deals actifs
    const restaurantsWithActiveDeals = (restaurants || []).map(restaurant => ({
      ...restaurant,
      deals: (restaurant.deals || []).filter((deal: Deal) => deal.is_active)
    })) as RestaurantWithDeals[]

    return restaurantsWithActiveDeals
  } catch (err: any) {
    console.error('Erreur lors de la récupération des restaurants:', err)
    throw err
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

  return `
    <div class="popup-content">
      <h3>${restaurant.name}</h3>
      ${restaurant.address ? `<p><strong>📍</strong> ${restaurant.address}</p>` : ''}
      ${restaurant.phone ? `<p><strong>📞</strong> ${restaurant.phone}</p>` : ''}
      ${restaurant.description ? `<p>${restaurant.description}</p>` : ''}
      ${dealsHtml}
    </div>
  `
}

// Créer une icône personnalisée pour les marqueurs
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

// Ajouter un marqueur sur la carte
const addMarker = (restaurant: RestaurantWithDeals) => {
  if (!map || !restaurant.lat || !restaurant.lng) return

  const marker = L.marker([restaurant.lat, restaurant.lng], {
    icon: createCustomIcon()
  })

  marker.bindPopup(createPopupContent(restaurant), {
    maxWidth: 300,
    className: 'custom-popup'
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

// Initialiser la carte Leaflet
const initMap = async () => {
  try {
    isLoading.value = true
    error.value = null

    if (!mapContainer.value) {
      throw new Error('Conteneur de carte non trouvé')
    }

    // Charger les restaurants
    const restaurants = await fetchRestaurants()
    restaurantCount.value = restaurants.length

    // Si la carte existe déjà, la détruire avant de la recréer
    if (map) {
      map.remove()
      map = null
    }
    markers.clear()

    // Créer la carte
    map = L.map(mapContainer.value, {
      center: restaurants.length > 0
        ? [restaurants[0].lat!, restaurants[0].lng!]
        : defaultCenter,
      zoom: 13,
      zoomControl: true,
      attributionControl: true
    })

    // Ajouter la couche de tuiles OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 19
    }).addTo(map)

    // Ajouter les marqueurs
    const markerGroup = L.featureGroup()
    restaurants.forEach((restaurant) => {
      addMarker(restaurant)
      const marker = markers.get(restaurant.id)
      if (marker) {
        markerGroup.addLayer(marker)
      }
    })

    // Ajuster la vue pour afficher tous les marqueurs
    if (markers.size > 0) {
      map.fitBounds(markerGroup.getBounds().pad(0.1), {
        maxZoom: 16
      })
    } else {
      map.setView(defaultCenter, 13)
    }

    isLoading.value = false
  } catch (err: any) {
    console.error('Erreur lors de l\'initialisation de la carte:', err)
    error.value = err.message || 'Erreur lors du chargement de la carte'
    isLoading.value = false
  }
}

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

            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: deals || []
            }

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

            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: deals || []
            }

            updateMarker(restaurantWithDeals)
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
            const restaurantWithDeals: RestaurantWithDeals = {
              ...restaurant,
              deals: (restaurant.deals || []).filter((d: Deal) => d.is_active)
            }

            // Mettre à jour le marqueur
            if (markers.has(restaurantId)) {
              updateMarker(restaurantWithDeals)
            } else {
              // Si le restaurant n'était pas sur la carte, l'ajouter
              addMarker(restaurantWithDeals)
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
              const restaurantWithDeals: RestaurantWithDeals = {
                ...restaurant,
                deals: (restaurant.deals || []).filter((d: Deal) => d.is_active)
              }
              updateMarker(restaurantWithDeals)
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
  z-index: 1;
  margin: 0 0;
}

.map-container {
  width: 100%;
  height: 100%;
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
  font-size: 0.85rem;
}

.popup-deals li {
  margin: 0.25rem 0;
}

.leaflet-popup-content-wrapper {
  border-radius: 0.5rem;
}

.leaflet-popup-tip {
  background: white;
}
</style>

