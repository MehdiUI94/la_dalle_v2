import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'
import { useRestaurantOrders } from './useRestaurantOrders'

type RestaurantVisit = Database['public']['Tables']['restaurant_visits']['Row']

export function useQRScan() {
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Générer un QR code pour un restaurant
  const generateQRCodeData = (restaurantId: string): string => {
    // Format: "LA_DALLE:VISIT:{restaurantId}:{timestamp}"
    const timestamp = Date.now()
    return `LA_DALLE:VISIT:${restaurantId}:${timestamp}`
  }

  // Valider et parser les données du QR code
  const parseQRCodeData = (qrData: string): { restaurantId: string; timestamp: number } | null => {
    const parts = qrData.split(':')
    if (parts.length !== 4 || parts[0] !== 'LA_DALLE' || parts[1] !== 'VISIT') {
      return null
    }
    
    const restaurantId = parts[2]
    const timestamp = parseInt(parts[3], 10)
    
    if (!restaurantId || isNaN(timestamp)) {
      return null
    }
    
    return { restaurantId, timestamp }
  }

  // Enregistrer une visite vérifiée
  const recordVisit = async (clientId: string, qrCodeData: string): Promise<RestaurantVisit | null> => {
    try {
      isLoading.value = true
      error.value = null

      // Parser les données du QR code
      const parsed = parseQRCodeData(qrCodeData)
      if (!parsed) {
        throw new Error('QR code invalide')
      }

      const { restaurantId } = parsed

      // Vérifier que le restaurant existe
      const { data: restaurant, error: restaurantError } = await supabase
        .from('restaurants')
        .select('id')
        .eq('id', restaurantId)
        .single()

      if (restaurantError || !restaurant) {
        throw new Error('Restaurant introuvable')
      }

      // Vérifier si une visite existe déjà aujourd'hui pour cet étudiant et ce restaurant
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      const tomorrow = new Date(today)
      tomorrow.setDate(tomorrow.getDate() + 1)

      const { data: existingVisit } = await supabase
        .from('restaurant_visits')
        .select('id')
        .eq('etudiant_id', clientId)
        .eq('restaurant_id', restaurantId)
        .gte('scanned_at', today.toISOString())
        .lt('scanned_at', tomorrow.toISOString())
        .maybeSingle()

      if (existingVisit) {
        // Visite déjà enregistrée aujourd'hui
        return null
      }

      // Enregistrer la visite
      const { data: visit, error: insertError } = await supabase
        .from('restaurant_visits')
        .insert({
          etudiant_id: clientId,
          restaurant_id: restaurantId,
          qr_code_data: qrCodeData,
          scanned_at: new Date().toISOString()
        })
        .select()
        .single()

      if (insertError) throw insertError

      // Créer automatiquement une commande à partir de la visite
      if (visit) {
        const { createOrderFromVisit } = useRestaurantOrders()
        await createOrderFromVisit(visit.id, clientId, restaurantId)
      }

      return visit
    } catch (err: any) {
      console.error('Erreur lors de l\'enregistrement de la visite:', err)
      error.value = err.message || 'Erreur lors de l\'enregistrement de la visite'
      return null
    } finally {
      isLoading.value = false
    }
  }

  // Vérifier si un étudiant a déjà visité un restaurant
  const hasVisitedRestaurant = async (clientId: string, restaurantId: string): Promise<boolean> => {
    try {
      const { data, error: visitError } = await supabase
        .from('restaurant_visits')
        .select('id')
        .eq('etudiant_id', clientId)
        .eq('restaurant_id', restaurantId)
        .limit(1)
        .maybeSingle()

      if (visitError) throw visitError

      return !!data
    } catch (err: any) {
      console.error('Erreur lors de la vérification de la visite:', err)
      return false
    }
  }

  // Obtenir toutes les visites d'un étudiant
  const getClientVisits = async (clientId: string): Promise<RestaurantVisit[]> => {
    try {
      const { data, error: visitsError } = await supabase
        .from('restaurant_visits')
        .select('*')
        .eq('etudiant_id', clientId)
        .order('scanned_at', { ascending: false })

      if (visitsError) throw visitsError

      return data || []
    } catch (err: any) {
      console.error('Erreur lors de la récupération des visites:', err)
      return []
    }
  }

  return {
    isLoading,
    error,
    generateQRCodeData,
    parseQRCodeData,
    recordVisit,
    hasVisitedRestaurant,
    getClientVisits
  }
}

