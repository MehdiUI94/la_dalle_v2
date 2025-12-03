<template>
  <div class="container mx-auto px-4 py-6 pb-24">
    <h2 class="text-2xl font-display font-bold text-gray-900 mb-4">
      Tous les deals 🎯
    </h2>

    <FilterBar
      :selected-filter="selectedCategory"
      @filter="handleFilter"
    />

    <DealList :deals="filteredDeals" class="mt-6" />
  </div>
</template>

<script setup lang="ts">
import FilterBar from '@/components/deals/FilterBar.vue'
import DealList from '@/components/deals/DealList.vue'
import { useDeals } from '@/composables/useDeals'

const { filteredDeals, selectedCategory, filterDeals } = useDeals()

const handleFilter = (category: string) => {
  filterDeals(category as any)
}
</script>

