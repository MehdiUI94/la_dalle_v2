<template>
  <button
    @click="handleShare"
    class="p-2 rounded-full bg-gray-100 hover:bg-primary-100 text-gray-600 hover:text-primary-600 transition-all duration-200 hover:scale-110 active:scale-95"
    aria-label="Partager ce deal"
  >
    <Share2 :size="18" />
  </button>
</template>

<script setup lang="ts">
import { Share2 } from 'lucide-vue-next'
import { useShare } from '@/composables/useShare'
import type { Deal } from '@/types/deal'

const props = defineProps<{
  deal: Deal
}>()

const { share } = useShare()

const handleShare = () => {
  share(props.deal)
}
</script>

