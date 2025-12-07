<template>
  <div class="map-preview">
    <div ref="mapContainer" class="map-container"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

interface Props {
  lat: number
  lng: number
  address?: string
}

const props = defineProps<Props>()

const mapContainer = ref<HTMLElement | null>(null)
let map: L.Map | null = null
let marker: L.Marker | null = null

const initMap = () => {
  if (!mapContainer.value) return

  // Créer la carte
  map = L.map(mapContainer.value, {
    center: [props.lat, props.lng],
    zoom: 15,
    zoomControl: true,
    attributionControl: true
  })

  // Ajouter la couche de tuiles OpenStreetMap
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  }).addTo(map)

  // Ajouter le marqueur
  const userIcon = L.divIcon({
    className: 'user-marker-preview',
    html: `
      <div style="
        background-color: #667eea;
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

  marker = L.marker([props.lat, props.lng], { icon: userIcon })
  marker.addTo(map)

  if (props.address) {
    marker.bindPopup(props.address)
  }
}

const updateMap = () => {
  if (!map || !marker) return

  map.setView([props.lat, props.lng], 15)
  marker.setLatLng([props.lat, props.lng])
  
  if (props.address && marker.getPopup()) {
    marker.setPopupContent(props.address)
  }
}

watch(() => [props.lat, props.lng, props.address], () => {
  if (map && marker) {
    updateMap()
  }
})

onMounted(() => {
  initMap()
})

onUnmounted(() => {
  if (marker && map) {
    map.removeLayer(marker)
    marker = null
  }
  if (map) {
    map.remove()
    map = null
  }
})
</script>

<style scoped>
.map-preview {
  width: 100%;
  height: 300px;
  border-radius: 0.75rem;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.map-container {
  width: 100%;
  height: 100%;
}
</style>

<style>
.user-marker-preview {
  background: transparent !important;
  border: none !important;
}
</style>

