<template>
  <nav class="fixed bottom-0 left-0 right-0 z-50 glass-effect border-t border-primary-100">
    <div class="flex justify-around py-2">
      <router-link
        v-for="item in navItems"
        :key="item.path"
        :to="item.path"
        :class="[
          'flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all duration-200',
          isActive(item.path)
            ? 'text-primary-600 bg-primary-50'
            : 'text-gray-600 hover:text-primary-500'
        ]"
      >
        <component :is="item.icon" :size="20" />
        <span class="text-xs font-medium">{{ item.label }}</span>
      </router-link>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { Home, Gift, MapPin, User } from 'lucide-vue-next'

const route = useRoute()

const navItems = [
  { path: '/', icon: Home, label: 'Accueil' },
  { path: '/deals', icon: Gift, label: 'Deals' },
  { path: '/map', icon: MapPin, label: 'Carte' },
  { path: '/profile', icon: User, label: 'Profil' },
]

const isActive = (path: string) => {
  return route.path === path
}
</script>

