<template>
  <div class="onboarding-view">
    <BackButton />
    <h2>Onboarding Étudiant</h2>
    <p>Formulaire d'inscription étudiant à venir...</p>
  </div>
</template>

<script setup lang="ts">
import BackButton from '@/components/shared/BackButton.vue'
</script>

<style scoped>
.onboarding-view {
  padding: 2rem 80px;
  color: white;
}

@media (max-width: 768px) {
  .onboarding-view {
    padding: 2rem 1rem;
  }
}
</style>



