import { onMounted } from 'vue'
import { useDealsStore } from '@/stores/deals'

export function useDeals() {
  const store = useDealsStore()

  onMounted(() => {
    if (store.deals.length === 0) {
      store.fetchDeals()
    }
  })

  return {
    deals: store.deals,
    featuredDeals: store.featuredDeals,
    filteredDeals: store.filteredDeals,
    selectedCategory: store.selectedCategory,
    filterDeals: store.filterDeals,
    toggleFavorite: store.toggleFavorite,
    isFavorite: store.isFavorite
  }
}

