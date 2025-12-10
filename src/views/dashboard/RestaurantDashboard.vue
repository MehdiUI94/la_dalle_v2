<template>
  <div class="dashboard-view">
    <BackButton />
    <h2 class="page-title section-title">DASHBOARD RESTAURANT</h2>
    <div class="dashboard-card">
      <p class="body-text">Gestion des deals à venir...</p>
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
  color: var(--foreground);
}

.page-title {
  margin-bottom: 2rem;
}

.dashboard-card {
  background: var(--background);
  padding: 2rem;
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
}

@media (max-width: 768px) {
  .dashboard-view {
    padding: 2rem 1rem;
  }
}
</style>



