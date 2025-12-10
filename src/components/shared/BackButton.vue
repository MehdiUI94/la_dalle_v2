<template>
  <a @click.prevent="goBack" href="#" class="back-button" aria-label="Retour">
    <span class="chevron">‹</span>
    <span class="back-text body-text">{{ backText }}</span>
  </a>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const backText = computed(() => {
  // Si on vient de l'accueil, afficher "Retour à l'accueil"
  if (route.meta.fromHome === true) {
    return 'Retour à l\'accueil'
  }
  return 'Retour'
})

const goBack = () => {
  // Si on vient de l'accueil, aller à l'accueil
  if (route.meta.fromHome === true) {
    router.push('/')
  } else {
    // Sinon, utiliser l'historique du navigateur
    if (window.history.length > 1) {
      router.back()
    } else {
      // Si pas d'historique, aller à l'accueil par défaut
      router.push('/')
    }
  }
}
</script>

<style scoped>
.back-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 0.5rem;
  padding: 0.5rem 1rem;
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  backdrop-filter: blur(10px);
  text-decoration: none;
}

.back-button:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateX(-2px);
}

.back-button:active {
  transform: translateX(0);
  opacity: 0.8;
  background: rgba(255, 255, 255, 0.1);
}

.chevron {
  font-size: 1.5rem;
  line-height: 1;
  font-weight: 300;
}


@media (max-width: 640px) {
  .back-button {
    padding: 0.4rem 0.75rem;
  }

  .chevron {
    font-size: 1.3rem;
  }
}
</style>

