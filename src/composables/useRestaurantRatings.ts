import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'
import { useQRScan } from './useQRScan'

type RestaurantRating = Database['public']['Tables']['restaurant_ratings']['Row']

export function useRestaurantRatings() {
  const isLoading = ref(false)
  const error = ref<string | null>(null)
  const { hasVisitedRestaurant } = useQRScan()

  // Obtenir la note moyenne d'un restaurant
  const getRestaurantAverageRating = async (restaurantId: string): Promise<number | null> => {
    try {
      const { data, error: ratingError } = await supabase
        .rpc('calculate_restaurant_average_rating', { restaurant_uuid: restaurantId })

      if (ratingError) throw ratingError

      return data ? parseFloat(data.toString()) : null
    } catch (err: unknown) {
      console.error('Erreur lors du calcul de la note moyenne:', err)
      return null
    }
  }

  // Obtenir toutes les notes moyennes pour plusieurs restaurants
  // Retourne null pour les restaurants sans notes (au lieu de 0)
  const getRestaurantsAverageRatings = async (restaurantIds: string[]): Promise<Map<string, number | null>> => {
    const ratingsMap = new Map<string, number | null>()
    
    // Si aucun restaurant, retourner une map vide
    if (!restaurantIds || restaurantIds.length === 0) {
      return ratingsMap
    }
    
    try {
      const { data, error: ratingsError } = await supabase
        .from('restaurant_ratings')
        .select('restaurant_id, rating')
        .in('restaurant_id', restaurantIds)

      // Si erreur, retourner une map vide sans bloquer
      if (ratingsError) {
        console.warn('Erreur lors de la récupération des notes:', ratingsError.message)
        return ratingsMap
      }

      // Initialiser tous les restaurants avec null (pas de note)
      restaurantIds.forEach(id => {
        ratingsMap.set(id, null)
      })

      // Calculer la moyenne pour chaque restaurant qui a des notes
      if (data && Array.isArray(data) && data.length > 0) {
        const ratingsByRestaurant = new Map<string, number[]>()
        
        data.forEach((rating: { restaurant_id: string; rating: number }) => {
          if (rating && rating.restaurant_id && typeof rating.rating === 'number') {
            if (!ratingsByRestaurant.has(rating.restaurant_id)) {
              ratingsByRestaurant.set(rating.restaurant_id, [])
            }
            ratingsByRestaurant.get(rating.restaurant_id)!.push(rating.rating)
          }
        })

        // Calculer la moyenne pour chaque restaurant qui a des notes
        ratingsByRestaurant.forEach((ratings, restaurantId) => {
          if (ratings.length > 0) {
            const sum = ratings.reduce((acc, r) => acc + r, 0)
            const average = Math.round((sum / ratings.length) * 10) / 10
            ratingsMap.set(restaurantId, average)
          }
        })
      }
    } catch (err: unknown) {
      console.error('Erreur lors de la récupération des notes:', err)
      // En cas d'erreur, retourner une map vide pour ne pas bloquer l'affichage
    }

    return ratingsMap
  }

  // Obtenir la note d'un étudiant pour un restaurant
  const getClientRating = async (clientId: string, restaurantId: string): Promise<RestaurantRating | null> => {
    try {
      const { data, error: ratingError } = await supabase
        .from('restaurant_ratings')
        .select('*')
        .eq('etudiant_id', clientId)
        .eq('restaurant_id', restaurantId)
        .maybeSingle()

      if (ratingError) throw ratingError

      return data
    } catch (err: unknown) {
      console.error('Erreur lors de la récupération de la note de l\'étudiant:', err)
      return null
    }
  }

  // Vérifier si l'étudiant peut noter le restaurant (doit avoir visité au moins une fois)
  const canRateRestaurant = async (clientId: string, restaurantId: string): Promise<boolean> => {
    try {
      return await hasVisitedRestaurant(clientId, restaurantId)
    } catch (err) {
      console.error('Erreur lors de la vérification de la possibilité de noter:', err)
      return false
    }
  }

  // Ajouter ou mettre à jour une note (uniquement si l'étudiant a visité le restaurant)
  const rateRestaurant = async (
    clientId: string,
    restaurantId: string,
    rating: number,
    comment?: string | null
  ): Promise<RestaurantRating | null> => {
    try {
      isLoading.value = true
      error.value = null

      // Vérifier que l'étudiant a visité le restaurant au moins une fois
      const hasVisited = await hasVisitedRestaurant(clientId, restaurantId)
      if (!hasVisited) {
        throw new Error('Vous devez avoir visité ce restaurant au moins une fois avant de pouvoir le noter')
      }

      // Vérifier si une note existe déjà
      const existingRating = await getClientRating(clientId, restaurantId)

      if (existingRating) {
        // Mettre à jour la note existante
        const { data, error: updateError } = await supabase
          .from('restaurant_ratings')
          .update({
            rating,
            comment: comment ?? null,
            updated_at: new Date().toISOString()
          })
          .eq('id', existingRating.id)
          .select()
          .single()

        if (updateError) throw updateError
        return data
      } else {
        // Créer une nouvelle note
        const { data, error: insertError } = await supabase
          .from('restaurant_ratings')
          .insert({
            etudiant_id: clientId,
            restaurant_id: restaurantId,
            rating,
            comment: comment ?? null
          })
          .select()
          .single()

        if (insertError) throw insertError
        return data
      }
    } catch (err: unknown) {
      console.error('Erreur lors de l\'ajout/mise à jour de la note:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de l\'enregistrement de la note')
      error.value = error.message
      return null
    } finally {
      isLoading.value = false
    }
  }

  // Supprimer une note
  const deleteRating = async (clientId: string, restaurantId: string): Promise<boolean> => {
    try {
      isLoading.value = true
      error.value = null

      const { error: deleteError } = await supabase
        .from('restaurant_ratings')
        .delete()
        .eq('etudiant_id', clientId)
        .eq('restaurant_id', restaurantId)

      if (deleteError) throw deleteError
      return true
    } catch (err: unknown) {
      console.error('Erreur lors de la suppression de la note:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la suppression de la note')
      error.value = error.message
      return false
    } finally {
      isLoading.value = false
    }
  }

  return {
    isLoading,
    error,
    getRestaurantAverageRating,
    getRestaurantsAverageRatings,
    getClientRating,
    canRateRestaurant,
    rateRestaurant,
    deleteRating
  }
}

