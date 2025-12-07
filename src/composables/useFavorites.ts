import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'

type Favorite = Database['public']['Tables']['favorites']['Row']

export function useFavorites() {
  const favorites = ref<Favorite[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Charger les favoris d'un étudiant
  const loadFavorites = async (clientId: string) => {
    try {
      isLoading.value = true
      error.value = null

      const { data, error: favoritesError } = await supabase
        .from('favorites')
        .select('*')
        .eq('etudiant_id', clientId)

      if (favoritesError) throw favoritesError

      favorites.value = data || []
    } catch (err: any) {
      console.error('Erreur lors du chargement des favoris:', err)
      error.value = err.message || 'Erreur lors du chargement des favoris'
    } finally {
      isLoading.value = false
    }
  }

  // Vérifier si un deal est favori
  const isFavorite = (dealId: string): boolean => {
    return favorites.value.some(fav => fav.deal_id === dealId)
  }

  // Vérifier si un restaurant a des deals favoris
  const hasFavoriteDeals = (restaurantId: string, dealIds: string[]): boolean => {
    return dealIds.some(dealId => isFavorite(dealId))
  }

  // Obtenir les IDs des deals favoris
  const getFavoriteDealIds = (): string[] => {
    return favorites.value.map(fav => fav.deal_id)
  }

  return {
    favorites,
    isLoading,
    error,
    loadFavorites,
    isFavorite,
    hasFavoriteDeals,
    getFavoriteDealIds
  }
}

