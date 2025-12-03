<template>
  <div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
    <button
      v-for="category in categories"
      :key="category.id"
      @click="$emit('filter', category.id)"
      :class="[
        'px-4 py-2 rounded-xl font-medium whitespace-nowrap transition-all duration-200 hover:scale-105 active:scale-95',
        selectedFilter === category.id
          ? 'bg-gradient-to-r from-primary-500 to-accent-500 text-white shadow-lg'
          : 'bg-white text-gray-700 hover:bg-gray-50'
      ]"
    >
      <span class="mr-2">{{ category.emoji }}</span>
      {{ category.label }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { CATEGORIES } from '@/utils/constants'
import type { DealCategory } from '@/types/deal'

defineProps<{
  selectedFilter: DealCategory
}>()

defineEmits<{
  filter: [category: DealCategory]
}>()

const categories = CATEGORIES
</script>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>

