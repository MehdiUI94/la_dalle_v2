<template>
  <div id="app">
    <PageHeader v-if="showHeader" />
    <main class="main-content" :class="{ 'with-header': showHeader, 'with-footer': showBottomNav }">
      <CustomScrollbar>
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
}

.main-content.with-header {
  padding-top: 0; /* Le header est sticky, pas besoin de padding */
}

.main-content.with-footer {
  /* Pas de padding-bottom pour éviter de cacher le contenu */
}

/* Wrapper pour le contenu */
.main-content-wrapper {
  /* Supprimer min-height pour éviter les problèmes de scroll inutile */
}
</style>

