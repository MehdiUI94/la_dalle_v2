<template>
  <div class="onboarding-view">
    <BackButton />
    <h2 class="section-title">ONBOARDING RESTAURANT</h2>
    <p class="body-text">Formulaire d'inscription restaurant à venir...</p>
  </div>
</template>

<script setup lang="ts">
import BackButton from '@/components/shared/BackButton.vue'
</script>

<style scoped>
.onboarding-view {
  padding: 2rem 80px;
  color: var(--foreground);
}

@media (max-width: 768px) {
  .onboarding-view {
    padding: 2rem 1rem;
  }
}
</style>



