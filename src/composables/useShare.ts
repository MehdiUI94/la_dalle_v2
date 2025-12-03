import { shareDeal } from '@/utils/share'
import type { Deal } from '@/types/deal'
import { useUserStore } from '@/stores/user'

export function useShare() {
  const userStore = useUserStore()

  const share = async (deal: Deal) => {
    try {
      await shareDeal(deal)
      // Récompenser l'utilisateur pour le partage
      userStore.updatePoints(10)
    } catch (error) {
      console.error('Erreur lors du partage:', error)
    }
  }

  return {
    share
  }
}

