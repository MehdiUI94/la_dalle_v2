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
  height: 100%;
  display: flex;
  flex-direction: column;
  color: var(--foreground);
  position: relative;
  z-index: 1;
}

.map-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

.map-view :deep(.restaurant-map) {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

@media (max-width: 768px) {
  .map-view {
    padding: 2rem 1rem;
  }
}
</style>

