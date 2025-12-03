<template>
  <span
    :class="[
      'px-3 py-1 rounded-full text-xs font-semibold inline-flex items-center gap-1',
      variant === 'primary' ? 'bg-primary-100 text-primary-700' : 'bg-accent-100 text-accent-700'
    ]"
  >
    <span v-if="emoji">{{ emoji }}</span>
    <slot />
  </span>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  variant?: 'primary' | 'accent'
  emoji?: string
}>(), {
  variant: 'accent'
})
</script>

