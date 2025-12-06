<template>
  <div class="map-view">
    <h2 class="page-title">Carte des Restaurants</h2>
    <RestaurantMap />
  </div>
</template>

<script setup lang="ts">
import RestaurantMap from '@/components/map/RestaurantMap.vue'
</script>

<style scoped>
.map-view {
  padding: 2rem 40px;
  min-height: calc(100vh - 140px);
  color: white;
  position: relative;
  z-index: 1;
}

.page-title {
  font-size: 2rem;
  margin-bottom: 2rem;
}

@media (max-width: 768px) {
  .map-view {
    padding: 2rem 1rem;
  }
}
</style>

