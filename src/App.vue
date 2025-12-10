<template>
  <div id="app">
    <PageHeader v-if="showHeader" />
    <main class="main-content" :class="{ 'with-header': showHeader, 'with-footer': showBottomNav }">
      <CustomScrollbar :has-header="showHeader" :has-footer="showBottomNav">
        <div class="main-content-wrapper">
          <router-view v-slot="{ Component, route }">
            <Transition :name="route.meta.transition || 'fade'" mode="out-in">
              <component :is="Component" />
            </Transition>
          </router-view>
        </div>
      </CustomScrollbar>
    </main>
    <BottomNav v-if="showBottomNav" />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useUserStore } from '@/stores/user'
import { useLocationStore } from '@/stores/location'
import PageHeader from './components/layout/PageHeader.vue'
import BottomNav from './components/layout/BottomNav.vue'
import CustomScrollbar from './components/shared/CustomScrollbar.vue'

const route = useRoute()
const { isAuthenticated } = useAuth()
const userStore = useUserStore()
const locationStore = useLocationStore()

const showHeader = computed(() => {
  return isAuthenticated() && !route.meta.hideHeader
})

const showBottomNav = computed(() => {
  return !route.meta.hideBottomNav
})

// Charger les adresses quand l'utilisateur se connecte
watch(
  () => userStore.user,
  async (newUser) => {
    if (newUser?.role === 'etudiant' && newUser?.id) {
      await locationStore.loadAddresses(newUser.id)
    }
  },
  { immediate: true }
)
</script>

<style scoped>
#app {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
}

.main-content {
  flex: 1;
  overflow: hidden;
  position: relative;
  display: flex;
  flex-direction: column;
  min-height: 0; /* Important pour que flex fonctionne correctement */
}

.main-content.with-header {
  padding-top: 0; /* Le header est sticky, pas besoin de padding */
}

.main-content.with-footer {
  /* Padding-bottom pour éviter que le contenu soit caché par le BottomNav */
}

/* Wrapper pour le contenu */
.main-content-wrapper {
  width: 100%;
  min-height: 100%;
}

/* Ajouter padding-bottom uniquement quand le footer est visible */
.main-content.with-footer .main-content-wrapper {
  padding-bottom: 80px; /* Espace pour le BottomNav */
}

@media (max-width: 768px) {
  .main-content.with-footer .main-content-wrapper {
    padding-bottom: 80px; /* Garder 80px même sur mobile pour le cercle du BottomNav */
  }
}
</style>

