import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'

type RestaurantOrder = Database['public']['Tables']['restaurant_orders']['Row']

export interface RestaurantVisitWithOrder {
  id: string
  restaurant_id: string
  restaurant_name: string
  restaurant_address: string | null
  scanned_at: string
  order_count: number
  remaining_for_reward: number
  has_rating: boolean
  rating: number | null
  can_rate: boolean
}

export function useRestaurantOrders() {
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Créer une commande à partir d'une visite
  const createOrderFromVisit = async (visitId: string, etudiantId: string, restaurantId: string): Promise<RestaurantOrder | null> => {
    try {
      isLoading.value = true
      error.value = null

      const { data, error: insertError } = await supabase
        .from('restaurant_orders')
        .insert({
          etudiant_id: etudiantId,
          restaurant_id: restaurantId,
          visit_id: visitId
        })
        .select()
        .single()

      if (insertError) throw insertError

      return data
    } catch (err: unknown) {
      console.error('Erreur lors de la création de la commande:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la création de la commande')
      error.value = error.message
      return null
    } finally {
      isLoading.value = false
    }
  }

  // Obtenir le nombre de commandes d'un étudiant dans un restaurant
  const getOrderCount = async (etudiantId: string, restaurantId: string): Promise<number> => {
    try {
      const { count, error: countError } = await supabase
        .from('restaurant_orders')
        .select('*', { count: 'exact', head: true })
        .eq('etudiant_id', etudiantId)
        .eq('restaurant_id', restaurantId)

      if (countError) throw countError

      return count || 0
    } catch (err: unknown) {
      console.error('Erreur lors du comptage des commandes:', err)
      return 0
    }
  }

  // Obtenir le nombre de commandes restantes avant la récompense (10 commandes)
  const getRemainingOrdersForReward = async (etudiantId: string, restaurantId: string): Promise<number> => {
    try {
      const orderCount = await getOrderCount(etudiantId, restaurantId)
      const modulo = orderCount % 10
      const remaining = modulo === 0 ? 0 : 10 - modulo
      return remaining
    } catch (err: unknown) {
      console.error('Erreur lors du calcul des commandes restantes:', err)
      return 10
    }
  }

  // Obtenir toutes les visites avec les informations de commandes et notes
  const getVisitsWithOrders = async (etudiantId: string): Promise<RestaurantVisitWithOrder[]> => {
    try {
      isLoading.value = true
      error.value = null

      // Récupérer toutes les visites avec les restaurants
      const { data: visits, error: visitsError } = await supabase
        .from('restaurant_visits')
        .select(`
          id,
          restaurant_id,
          scanned_at,
          restaurants (
            id,
            name,
            address
          )
        `)
        .eq('etudiant_id', etudiantId)
        .order('scanned_at', { ascending: false })

      if (visitsError) throw visitsError

      if (!visits) return []

      // Pour chaque visite, récupérer le nombre de commandes et les notes
      interface VisitWithRestaurant {
        id: string
        restaurant_id: string
        scanned_at: string
        restaurants: {
          id: string
          name: string
          address: string | null
        } | {
          id: string
          name: string
          address: string | null
        }[]
      }
      
      const visitsWithOrders: RestaurantVisitWithOrder[] = await Promise.all(
        (visits as VisitWithRestaurant[]).map(async (visit) => {
          const restaurant = Array.isArray(visit.restaurants) ? visit.restaurants[0] : visit.restaurants
          
          const orderCount = await getOrderCount(etudiantId, visit.restaurant_id)
          const remainingForReward = await getRemainingOrdersForReward(etudiantId, visit.restaurant_id)

          // Vérifier si l'étudiant a déjà noté ce restaurant
          const { data: rating } = await supabase
            .from('restaurant_ratings')
            .select('rating')
            .eq('etudiant_id', etudiantId)
            .eq('restaurant_id', visit.restaurant_id)
            .maybeSingle()

          // Vérifier si l'étudiant peut noter (doit avoir visité au moins une fois)
          const { data: hasVisited } = await supabase
            .from('restaurant_visits')
            .select('id')
            .eq('etudiant_id', etudiantId)
            .eq('restaurant_id', visit.restaurant_id)
            .limit(1)
            .maybeSingle()

          return {
            id: visit.id,
            restaurant_id: visit.restaurant_id,
            restaurant_name: restaurant?.name || 'Restaurant inconnu',
            restaurant_address: restaurant?.address || null,
            scanned_at: visit.scanned_at,
            order_count: orderCount,
            remaining_for_reward: remainingForReward,
            has_rating: !!rating,
            rating: rating?.rating || null,
            can_rate: !!hasVisited && !rating
          }
        })
      )

      return visitsWithOrders
    } catch (err: unknown) {
      console.error('Erreur lors de la récupération des visites avec commandes:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la récupération des visites')
      error.value = error.message
      return []
    } finally {
      isLoading.value = false
    }
  }

  return {
    isLoading,
    error,
    createOrderFromVisit,
    getOrderCount,
    getRemainingOrdersForReward,
    getVisitsWithOrders
  }
}

