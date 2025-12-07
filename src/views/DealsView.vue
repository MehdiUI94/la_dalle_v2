<template>
  <div class="deals-view">
    <h2 class="page-title">Mes restos</h2>
    <p class="page-subtitle">Découvrez les meilleures offres du moment</p>
    <div class="deals-container">
      <div class="deal-card">
        <h3>🍕 Pizza Margherita</h3>
        <p>1 pizza achetée = 1 pizza offerte</p>
        <span class="location">📍 11ème arrondissement</span>
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
  color: white;
}

.deals-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

.page-title {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.page-subtitle {
  opacity: 0.9;
  margin-bottom: 2rem;
}

.deals-container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.deal-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 1.5rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.deal-card h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
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



