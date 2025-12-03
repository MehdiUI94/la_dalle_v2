<template>
  <div
    class="bg-white rounded-2xl p-5 shadow-lg deal-glow hover:shadow-xl transition-all cursor-pointer"
    @click="$emit('click', deal)"
  >
    <div class="flex items-start justify-between mb-3">
      <div class="flex-1">
        <h3 class="font-display font-bold text-xl text-gray-900 mb-1">
          {{ deal.restaurant }}
        </h3>
        <p class="text-sm text-gray-600 mb-2">{{ deal.description }}</p>
      </div>
      <ShareButton :deal="deal" />
    </div>

    <div class="flex items-center gap-4 mb-4 text-sm text-gray-500 flex-wrap">
      <div class="flex items-center gap-1">
        <MapPin :size="16" />
        <span>{{ deal.arrondissement }}</span>
      </div>
      <div class="flex items-center gap-1">
        <Clock :size="16" />
        <span>{{ deal.hours }}</span>
      </div>
      <div v-if="deal.groupSize" class="flex items-center gap-1">
        <Users :size="16" />
        <span>Min {{ deal.groupSize }}</span>
      </div>
    </div>

    <div class="flex items-center justify-between">
      <div class="px-4 py-2 bg-gradient-to-r from-primary-500 to-accent-500 rounded-xl text-white font-bold">
        {{ deal.deal }}
      </div>
      <Badge v-if="deal.badge" variant="accent">
        {{ deal.badge }}
      </Badge>
    </div>
  </div>
</template>

<script setup lang="ts">
import { MapPin, Clock, Users } from 'lucide-vue-next'
import ShareButton from '@/components/shared/ShareButton.vue'
import Badge from '@/components/shared/Badge.vue'
import type { Deal } from '@/types/deal'

defineProps<{
  deal: Deal
}>()

defineEmits<{
  click: [deal: Deal]
}>()
</script>

