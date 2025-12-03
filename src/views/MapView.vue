<template>
  <div class="container mx-auto px-4 py-6 pb-24">
    <h2 class="text-2xl font-display font-bold text-gray-900 mb-4">
      Carte des deals 📍
    </h2>

    <RestaurantMap />
  </div>
</template>

<script setup lang="ts">
import RestaurantMap from '@/components/map/RestaurantMap.vue'
</script>

