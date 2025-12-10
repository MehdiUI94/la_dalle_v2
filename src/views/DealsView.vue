<template>
  <div class="deals-view">
    <p class="page-subtitle body-text">Découvrez les meilleures offres du moment</p>
    <div class="deals-container">
      <div class="deal-card">
        <h3 class="deal-title">🍕 PIZZA MARGHERITA</h3>
        <p class="body-text">1 pizza achetée = 1 pizza offerte</p>
        <span class="location body-text">📍 11ème arrondissement</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import BackButton from '@/components/shared/BackButton.vue'
</script>

<style scoped>
.deals-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: var(--foreground);
}

.deals-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

.page-title {
  margin-bottom: 0.5rem;
}

.page-subtitle {
  opacity: 0.9;
  margin-bottom: 2rem;
  font-weight: 500;
}

.deals-container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.deal-card {
  background: var(--background);
  padding: 1.5rem;
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
}

.deal-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  text-transform: uppercase;
}

.location {
  display: block;
  margin-top: 0.5rem;
  opacity: 0.8;
}

@media (max-width: 768px) {
  .deals-view {
    padding: 2rem 1rem;
  }
}
</style>



