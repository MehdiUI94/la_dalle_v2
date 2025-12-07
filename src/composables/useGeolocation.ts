import { ref } from 'vue'

export interface Coordinates {
  lat: number
  lng: number
}

export function useGeolocation() {
  const coordinates = ref<Coordinates | null>(null)
  const error = ref<string | null>(null)
  const isLoading = ref(false)

  // Obtenir la position géographique actuelle du navigateur
  const getCurrentPosition = (): Promise<Coordinates> => {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        reject(new Error('La géolocalisation n\'est pas supportée par votre navigateur'))
        return
      }

      isLoading.value = true
      error.value = null

      navigator.geolocation.getCurrentPosition(
        (position) => {
          const coords: Coordinates = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          }
          coordinates.value = coords
          isLoading.value = false
          resolve(coords)
        },
        (err) => {
          const errorMessage = err.message || 'Impossible d\'obtenir votre position'
          error.value = errorMessage
          isLoading.value = false
          reject(new Error(errorMessage))
        },
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0
        }
      )
    })
  }

  // Calculer la distance entre deux points en kilomètres (formule de Haversine)
  const calculateDistance = (
    lat1: number,
    lng1: number,
    lat2: number,
    lng2: number
  ): number => {
    const R = 6371 // Rayon de la Terre en km
    const dLat = ((lat2 - lat1) * Math.PI) / 180
    const dLng = ((lng2 - lng1) * Math.PI) / 180
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLng / 2) *
        Math.sin(dLng / 2)
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    return R * c
  }

  // Filtrer les restaurants dans un rayon donné (en km)
  const filterByRadius = <T extends { lat: number | null; lng: number | null }>(
    items: T[],
    centerLat: number,
    centerLng: number,
    radiusKm: number
  ): T[] => {
    return items.filter((item) => {
      if (!item.lat || !item.lng) return false
      const distance = calculateDistance(centerLat, centerLng, item.lat, item.lng)
      return distance <= radiusKm
    })
  }

  return {
    coordinates,
    error,
    isLoading,
    getCurrentPosition,
    calculateDistance,
    filterByRadius
  }
}

