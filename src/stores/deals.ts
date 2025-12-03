import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Deal, DealCategory } from '@/types/deal'
import { mockDeals } from '@/data/mockDeals'

export const useDealsStore = defineStore('deals', () => {
  const deals = ref<Deal[]>([])
  const selectedCategory = ref<DealCategory>('all')
  const favorites = ref<number[]>([])

  const featuredDeals = computed(() => {
    return deals.value.slice(0, 3)
  })

  const filteredDeals = computed(() => {
    if (selectedCategory.value === 'all') {
      return deals.value
    }
    return deals.value.filter(deal => deal.category === selectedCategory.value)
  })

  const favoriteDeals = computed(() => {
    return deals.value.filter(deal => favorites.value.includes(deal.id))
  })

  function fetchDeals() {
    // Simuler un appel API
    deals.value = mockDeals
  }

  function filterDeals(category: DealCategory) {
    selectedCategory.value = category
  }

  function toggleFavorite(dealId: number) {
    const index = favorites.value.indexOf(dealId)
    if (index > -1) {
      favorites.value.splice(index, 1)
    } else {
      favorites.value.push(dealId)
    }
  }

  function isFavorite(dealId: number): boolean {
    return favorites.value.includes(dealId)
  }

  return {
    deals,
    selectedCategory,
    favorites,
    featuredDeals,
    filteredDeals,
    favoriteDeals,
    fetchDeals,
    filterDeals,
    toggleFavorite,
    isFavorite
  }
})

