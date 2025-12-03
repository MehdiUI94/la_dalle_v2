<template>
  <div class="space-y-4">
    <TransitionGroup name="list" tag="div">
      <DealCard
        v-for="deal in deals"
        :key="deal.id"
        :deal="deal"
        class="list-item"
      />
    </TransitionGroup>
    <div v-if="deals.length === 0" class="text-center py-12 text-gray-500">
      Aucun deal disponible pour cette catégorie
    </div>
  </div>
</template>

<script setup lang="ts">
import DealCard from './DealCard.vue'
import type { Deal } from '@/types/deal'

defineProps<{
  deals: Deal[]
}>()
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.list-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

.list-move {
  transition: transform 0.3s ease;
}
</style>

