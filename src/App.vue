<template>
  <div id="app">
    <Header v-if="showHeader" />
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
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import Header from './components/layout/Header.vue'
import BottomNav from './components/layout/BottomNav.vue'
import CustomScrollbar from './components/shared/CustomScrollbar.vue'

const route = useRoute()

const showHeader = computed(() => {
  return !route.meta.hideHeader
})

const showBottomNav = computed(() => {
  return !route.meta.hideBottomNav
})
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
  /* Le main ne scroll pas directement */
}

.main-content.with-header {
  padding-top: 70px; /* Hauteur du header */
}

.main-content.with-footer {
  padding-bottom: 70px; /* Hauteur du footer */
}

/* Wrapper pour le contenu */
.main-content-wrapper {
  /* Supprimer min-height pour éviter les problèmes de scroll inutile */
}
</style>

