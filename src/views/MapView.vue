<template>
  <div class="map-view">
    <FilterBar v-model="filters" />
    
    <RestaurantMap :filters="filters" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import FilterBar from '@/components/map/FilterBar.vue'
import RestaurantMap from '@/components/map/RestaurantMap.vue'
import BackButton from '@/components/shared/BackButton.vue'
import type { FilterOptions } from '@/components/map/FilterBar.vue'

const filters = ref<FilterOptions>({
  minRating: null,
  maxDistance: null,
  hasPromos: false,
  favoritesOnly: false,
  foodType: null,
  diet: null
})
</script>

<style scoped>
.map-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: white;
  position: relative;
  z-index: 1;
}

.map-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

@media (max-width: 768px) {
  .map-view {
    padding: 2rem 1rem;
  }
}
</style>

