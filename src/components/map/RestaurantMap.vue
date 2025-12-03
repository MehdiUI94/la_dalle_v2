<template>
  <div class="relative w-full h-[600px] rounded-2xl overflow-hidden shadow-lg">
    <!-- Loading state -->
    <div v-if="isLoading" class="absolute inset-0 flex items-center justify-center bg-gray-100 z-10">
      <div class="text-center">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-500 mx-auto mb-4"></div>
        <p class="text-gray-600">Chargement de la carte...</p>
      </div>
    </div>

    <!-- Error state -->
    <div v-if="error" class="absolute inset-0 flex items-center justify-center bg-red-50 z-10">
      <div class="text-center p-6">
        <MapPin class="mx-auto text-red-500 mb-4" :size="48" />
        <p class="text-red-700 font-semibold mb-2">{{ error }}</p>
        <p class="text-sm text-red-600">Erreur lors du chargement de la carte</p>
      </div>
    </div>

    <!-- Map container -->
    <div ref="mapContainer" class="w-full h-full z-0"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import L from 'leaflet'
import { MapPin } from 'lucide-vue-next'
import { supabase } from '@/lib/supabaseClient'
import type { RestaurantProfile } from '@/types/profile'
import 'leaflet/dist/leaflet.css'

interface Deal {
  id: number
  title: string
  description: string | null
  is_active: boolean
}

interface RestaurantWithDeals extends RestaurantProfile {
  deals?: Deal[]
}

const mapContainer = ref<HTMLDivElement | null>(null)
const isLoading = ref(true)
const error = ref<string | null>(null)

let map: L.Map | null = null
let markers: L.Marker[] = []
let markerGroup: L.FeatureGroup | null = null
let updateTimer: number | null = null

// Centre par défaut : Paris
const defaultCenter: [number, number] = [48.8566, 2.3522]

// Récupérer les restaurants depuis Supabase
const fetchRestaurants = async (): Promise<RestaurantWithDeals[]> => {
  try {
    // Récupérer les restaurants avec leurs deals actifs
    const { data: restaurants, error: restaurantsError } = await supabase
      .from('restaurants')
      .select(`
        *,
        deals:deals!restaurant_id (
          id,
          title,
          description,
          is_active
        )
      `)
      .not('lat', 'is', null)
      .not('lng', 'is', null)

    if (restaurantsError) throw restaurantsError

    // Filtrer les restaurants qui ont des coordonnées et des deals actifs
    return (restaurants || []).filter((r: any) => {
      const activeDeals = r.deals?.filter((d: Deal) => d.is_active) || []
      return r.lat && r.lng && activeDeals.length > 0
    }) as RestaurantWithDeals[]
  } catch (err: any) {
    console.error('Erreur lors de la récupération des restaurants:', err)
    throw new Error('Impossible de charger les restaurants')
  }
}

// Créer le contenu du popup
const createPopupContent = (resto: RestaurantWithDeals): string => {
  const dealsHtml = resto.deals && resto.deals.length > 0
    ? `
      <div style="margin-top: 8px;">
        <p style="font-size: 11px; font-weight: 600; color: #374151; margin-bottom: 4px;">Deals disponibles :</p>
        ${resto.deals.map(deal => `
          <div style="font-size: 11px; color: #4B5563; margin-bottom: 2px;">
            🎯 ${deal.title}
          </div>
        `).join('')}
      </div>
    `
    : ''

  return `
    <div style="padding: 8px; min-width: 200px; font-family: Inter, sans-serif;">
      <h3 style="font-weight: 700; font-size: 16px; color: #111827; margin-bottom: 4px;">
        ${resto.name}
      </h3>
      <p style="font-size: 12px; color: #4B5563; margin-bottom: 4px;">
        ${resto.address || 'Adresse non disponible'}
      </p>
      ${resto.arrondissement ? `
        <p style="font-size: 11px; color: #EF4444; margin-bottom: 8px;">
          📍 ${resto.arrondissement}
        </p>
      ` : ''}
      ${dealsHtml}
    </div>
  `
}

// Mettre à jour les marqueurs sur la carte
const updateMarkers = (restaurants: RestaurantWithDeals[]) => {
  if (!map) return

  // Supprimer tous les marqueurs existants
  markers.forEach(marker => {
    marker.remove()
  })
  markers = []
  
  if (markerGroup) {
    markerGroup.clearLayers()
  } else {
    markerGroup = L.featureGroup()
  }

  // Ajouter les nouveaux marqueurs
  restaurants.forEach((restaurant) => {
    if (!restaurant.lat || !restaurant.lng) return

    const customIcon = L.divIcon({
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
          📍
        </div>
      `,
      iconSize: [40, 40],
      iconAnchor: [20, 40],
      popupAnchor: [0, -40]
    })

    const marker = L.marker([restaurant.lat, restaurant.lng], {
      icon: customIcon
    })

    marker.bindPopup(createPopupContent(restaurant), {
      maxWidth: 300,
      className: 'custom-popup'
    })

    marker.addTo(map)
    markerGroup!.addLayer(marker)
    markers.push(marker)
  })

  // Ajuster la vue si nécessaire
  if (markers.length > 0 && markerGroup.getLayers().length > 0) {
    const bounds = markerGroup.getBounds()
    if (bounds.isValid()) {
      map.fitBounds(bounds.pad(0.1), {
        maxZoom: 16
      })
    }
  }
}

// Calculer le temps jusqu'à minuit (00h00)
const getTimeUntilMidnight = (): number => {
  const now = new Date()
  const midnight = new Date()
  midnight.setHours(24, 0, 0, 0) // Prochain minuit
  
  return midnight.getTime() - now.getTime()
}

// Mettre à jour les données des restaurants
const refreshRestaurantData = async () => {
  try {
    console.log('🔄 Mise à jour des données des restaurants à 00h00...')
    const restaurants = await fetchRestaurants()
    updateMarkers(restaurants)
    console.log(`✅ ${restaurants.length} restaurants mis à jour`)
    
    // Reprogrammer pour le lendemain à minuit
    scheduleDailyUpdate()
  } catch (err: any) {
    console.error('❌ Erreur lors de la mise à jour des restaurants:', err)
  }
}

// Programmer la mise à jour quotidienne à 00h00
const scheduleDailyUpdate = () => {
  // Annuler le timer précédent s'il existe
  if (updateTimer !== null) {
    clearTimeout(updateTimer)
  }

  const timeUntilMidnight = getTimeUntilMidnight()
  
  console.log(`⏰ Prochaine mise à jour programmée dans ${Math.round(timeUntilMidnight / 1000 / 60)} minutes (à 00h00)`)
  
  updateTimer = window.setTimeout(() => {
    refreshRestaurantData()
  }, timeUntilMidnight)
}

// Initialiser la carte Leaflet
const initMap = async () => {
  try {
    isLoading.value = true
    error.value = null

    // Récupérer les restaurants
    const restaurants = await fetchRestaurants()

    if (!mapContainer.value) {
      throw new Error('Conteneur de carte non trouvé')
    }

    // Créer la carte Leaflet
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

    // Créer un groupe de marqueurs pour gérer les bounds
    markerGroup = L.featureGroup()

    // Ajouter les marqueurs pour chaque restaurant
    restaurants.forEach((restaurant) => {
      if (!restaurant.lat || !restaurant.lng) return

      // Créer un marqueur personnalisé avec une icône rouge
      const customIcon = L.divIcon({
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
            📍
          </div>
        `,
        iconSize: [40, 40],
        iconAnchor: [20, 40],
        popupAnchor: [0, -40]
      })

      const marker = L.marker([restaurant.lat, restaurant.lng], {
        icon: customIcon
      })

      // Ajouter le popup avec les informations du restaurant
      marker.bindPopup(createPopupContent(restaurant), {
        maxWidth: 300,
        className: 'custom-popup'
      })

      marker.addTo(map!)
      markerGroup.addLayer(marker)
      markers.push(marker)
    })

    // Ajuster la vue pour afficher tous les marqueurs
    if (markers.length > 0) {
      map.fitBounds(markerGroup.getBounds().pad(0.1), {
        maxZoom: 16
      })
    } else {
      // Si aucun restaurant, centrer sur Paris
      map.setView(defaultCenter, 13)
    }

    // Programmer la mise à jour quotidienne à 00h00
    scheduleDailyUpdate()

    isLoading.value = false
  } catch (err: any) {
    console.error('Erreur lors de l\'initialisation de la carte:', err)
    error.value = err.message || 'Erreur lors du chargement de la carte'
    isLoading.value = false
  }
}

onMounted(() => {
  initMap()
})

onUnmounted(() => {
  // Annuler le timer de mise à jour
  if (updateTimer !== null) {
    clearTimeout(updateTimer)
    updateTimer = null
  }
  
  // Nettoyer la carte
  if (map) {
    map.remove()
    map = null
  }
  markers = []
  markerGroup = null
})
</script>

<style scoped>
/* Styles pour les popups personnalisés */
:deep(.custom-popup .leaflet-popup-content-wrapper) {
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

:deep(.custom-popup .leaflet-popup-content) {
  margin: 0;
}

:deep(.custom-popup .leaflet-popup-tip) {
  background: white;
  border: none;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Styles pour les marqueurs personnalisés */
:deep(.custom-marker) {
  background: transparent;
  border: none;
}

/* Styles généraux Leaflet */
:deep(.leaflet-container) {
  font-family: 'Inter', sans-serif;
}

:deep(.leaflet-control-zoom) {
  border: none;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  border-radius: 8px;
  overflow: hidden;
}

:deep(.leaflet-control-zoom a) {
  background-color: white;
  color: #374151;
  border: none;
  width: 32px;
  height: 32px;
  line-height: 32px;
  font-size: 18px;
  font-weight: 600;
}

:deep(.leaflet-control-zoom a:hover) {
  background-color: #F3F4F6;
  color: #111827;
}

:deep(.leaflet-control-attribution) {
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 4px;
  padding: 4px 8px;
  font-size: 11px;
}
</style>
