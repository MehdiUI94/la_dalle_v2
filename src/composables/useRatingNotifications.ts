import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'

type RatingNotification = Database['public']['Tables']['rating_notifications']['Row']

export function useRatingNotifications() {
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Obtenir les notifications non lues d'un étudiant
  const getUnreadNotifications = async (clientId: string): Promise<RatingNotification[]> => {
    try {
      isLoading.value = true
      error.value = null

      const { data, error: notificationsError } = await supabase
        .from('rating_notifications')
        .select('*')
        .eq('etudiant_id', clientId)
        .eq('is_read', false)
        .order('notification_sent_at', { ascending: false })

      if (notificationsError) throw notificationsError

      return data || []
    } catch (err: any) {
      console.error('Erreur lors de la récupération des notifications:', err)
      error.value = err.message || 'Erreur lors de la récupération des notifications'
      return []
    } finally {
      isLoading.value = false
    }
  }

  // Marquer une notification comme lue
  const markAsRead = async (notificationId: string): Promise<boolean> => {
    try {
      isLoading.value = true
      error.value = null

      const { error: updateError } = await supabase
        .from('rating_notifications')
        .update({ is_read: true })
        .eq('id', notificationId)

      if (updateError) throw updateError

      return true
    } catch (err: any) {
      console.error('Erreur lors de la mise à jour de la notification:', err)
      error.value = err.message || 'Erreur lors de la mise à jour de la notification'
      return false
    } finally {
      isLoading.value = false
    }
  }

  // Marquer toutes les notifications comme lues
  const markAllAsRead = async (clientId: string): Promise<boolean> => {
    try {
      isLoading.value = true
      error.value = null

      const { error: updateError } = await supabase
        .from('rating_notifications')
        .update({ is_read: true })
        .eq('etudiant_id', clientId)
        .eq('is_read', false)

      if (updateError) throw updateError

      return true
    } catch (err: any) {
      console.error('Erreur lors de la mise à jour des notifications:', err)
      error.value = err.message || 'Erreur lors de la mise à jour des notifications'
      return false
    } finally {
      isLoading.value = false
    }
  }

  // Vérifier si une notification existe pour une visite donnée
  const hasNotificationForVisit = async (visitId: string): Promise<boolean> => {
    try {
      const { data, error: notificationError } = await supabase
        .from('rating_notifications')
        .select('id')
        .eq('visit_id', visitId)
        .maybeSingle()

      if (notificationError) throw notificationError

      return !!data
    } catch (err: any) {
      console.error('Erreur lors de la vérification de la notification:', err)
      return false
    }
  }

  // Obtenir le nombre de notifications non lues
  const getUnreadCount = async (clientId: string): Promise<number> => {
    try {
      const { count, error: countError } = await supabase
        .from('rating_notifications')
        .select('*', { count: 'exact', head: true })
        .eq('etudiant_id', clientId)
        .eq('is_read', false)

      if (countError) throw countError

      return count || 0
    } catch (err: any) {
      console.error('Erreur lors du comptage des notifications:', err)
      return 0
    }
  }

  return {
    isLoading,
    error,
    getUnreadNotifications,
    markAsRead,
    markAllAsRead,
    hasNotificationForVisit,
    getUnreadCount
  }
}

