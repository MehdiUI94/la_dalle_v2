<template>
  <router-link :to="backTo" class="back-link" aria-label="Retour">
    <span class="chevron-icon">‹</span>
    <span class="back-text body-text">{{ backText }}</span>
  </router-link>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const backText = computed(() => {
  // Si on vient de l'accueil, afficher "Retour à l'accueil"
  if (route.meta.fromHome === true) {
    return 'Retour à l\'accueil'
  }
  return 'Retour'
})

const backTo = computed(() => {
  // Si on vient de l'accueil, aller à l'accueil
  if (route.meta.fromHome === true) {
    return '/'
  }
  // Si une route précédente est spécifiée dans les meta, l'utiliser
  if (route.meta.fromRoute && typeof route.meta.fromRoute === 'string') {
    return route.meta.fromRoute
  }
  // Sinon, aller à l'accueil par défaut
  return '/'
})
</script>

<style scoped>
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
  margin-top: 40px;
  margin-bottom: 40px;
}

.back-link:hover {
  color: var(--primary);
}

.back-text {
  font-weight: 500;
  text-decoration: underline;
  text-decoration-color: var(--gray-500);
  text-underline-offset: 2px;
}

.chevron-icon {
  font-size: 1.2rem;
  color: var(--gray-500);
  transition: transform 0.2s, color 0.2s;
  margin-right: 0.25rem;
}

.back-link:hover .chevron-icon {
  color: var(--primary);
  transform: translateX(-2px);
}

@media (max-width: 640px) {
  .chevron-icon {
    font-size: 1rem;
  }
}
</style>

