import type { Deal } from '@/types/deal'

export async function shareDeal(deal: Deal): Promise<void> {
  const shareData = {
    title: `🍕 ${deal.restaurant} - LA DALLE`,
    text: `Découvre ce deal incroyable : ${deal.deal} !`,
    url: window.location.href
  }

  try {
    if (navigator.share) {
      await navigator.share(shareData)
    } else {
      // Fallback : copier dans le presse-papier
      await navigator.clipboard.writeText(
        `${shareData.title}\n${shareData.text}\n${shareData.url}`
      )
      alert('Deal copié dans le presse-papier ! 📋')
    }
  } catch (err) {
    // L'utilisateur a annulé le partage
    if ((err as Error).name !== 'AbortError') {
      console.error('Erreur de partage:', err)
    }
  }
}

