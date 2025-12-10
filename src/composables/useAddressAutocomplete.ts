import { ref, watch } from 'vue'

export interface AddressSuggestion {
  label: string
  value: string
  city: string
  postcode: string
  id: string
}

export function useAddressAutocomplete() {
  const suggestions = ref<AddressSuggestion[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const searchAddresses = async (query: string) => {
    if (query.length < 3) {
      suggestions.value = []
      return
    }

    try {
      isLoading.value = true
      error.value = null

      const response = await fetch(
        `https://api-adresse.data.gouv.fr/search/?q=${encodeURIComponent(query)}&limit=5`
      )

      if (!response.ok) {
        throw new Error('Erreur lors de la recherche d\'adresses')
      }

      const data = await response.json() as {
        features: Array<{
          properties: {
            label: string
            city: string
            postcode: string
            id?: string
          }
        }>
      }

      suggestions.value = data.features.map((feature) => {
        const props = feature.properties
        return {
          label: props.label,
          value: props.label,
          city: props.city,
          postcode: props.postcode,
          id: props.id || `${props.label}-${props.city}-${props.postcode}`
        }
      })
    } catch (err: unknown) {
      console.error('Erreur recherche adresse:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la recherche')
      error.value = error.message
      suggestions.value = []
    } finally {
      isLoading.value = false
    }
  }

  return {
    suggestions,
    isLoading,
    error,
    searchAddresses
  }
}

