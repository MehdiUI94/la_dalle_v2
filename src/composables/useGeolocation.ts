import { ref, onMounted } from 'vue'

export function useGeolocation() {
  const coordinates = ref<{ lat: number; lng: number } | null>(null)
  const error = ref<string | null>(null)
  const isLoading = ref(false)

  const getCurrentPosition = () => {
    isLoading.value = true
    if (!navigator.geolocation) {
      error.value = 'La géolocalisation n\'est pas supportée par votre navigateur'
      isLoading.value = false
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        coordinates.value = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        }
        isLoading.value = false
      },
      (err) => {
        error.value = `Erreur de géolocalisation: ${err.message}`
        isLoading.value = false
      }
    )
  }

  onMounted(() => {
    // Optionnel : demander la position au chargement
    // getCurrentPosition()
  })

  return {
    coordinates,
    error,
    isLoading,
    getCurrentPosition
  }
}

