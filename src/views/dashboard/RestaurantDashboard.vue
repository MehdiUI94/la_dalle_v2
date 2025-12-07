<template>
  <div class="dashboard-view">
    <BackButton />
    <h2 class="page-title">Dashboard Restaurant</h2>
    <div class="dashboard-card">
      <p>Gestion des deals à venir...</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import BackButton from '@/components/shared/BackButton.vue'
</script>

<style scoped>
.dashboard-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: white;
}

.page-title {
  font-size: 2rem;
  margin-bottom: 2rem;
}

.dashboard-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

@media (max-width: 768px) {
  .dashboard-view {
    padding: 2rem 1rem;
  }
}
</style>



