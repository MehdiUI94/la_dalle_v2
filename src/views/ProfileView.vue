<template>
  <div class="container mx-auto px-4 py-6 pb-24">
    <div v-if="!userStore.user" class="text-center py-12">
      <p class="text-gray-600 mb-4">Tu dois te connecter pour voir ton profil</p>
      <router-link
        to="/login"
        class="inline-block px-6 py-3 bg-gradient-to-r from-primary-500 to-accent-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition"
      >
        Se connecter
      </router-link>
    </div>

    <div v-else class="text-center mb-8">
      <div class="w-24 h-24 bg-gradient-to-r from-primary-500 to-accent-500 rounded-full mx-auto mb-4 flex items-center justify-center text-4xl">
        👤
      </div>
      <h2 class="text-2xl font-display font-bold text-gray-900 mb-1">
        Mon Profil
      </h2>
      <p class="text-gray-600">@{{ userStore.user.username }}</p>
      
      <button
        @click="handleLogout"
        class="mt-4 px-4 py-2 text-sm text-gray-600 hover:text-red-500 transition"
      >
        Se déconnecter
      </button>
    </div>

    <div class="grid grid-cols-2 gap-4 mb-6">
      <div
        v-for="(stat, index) in stats"
        :key="stat.label"
        class="glass-effect rounded-xl p-4 text-center"
      >
        <component :is="stat.icon" class="mx-auto text-primary-500 mb-2" :size="24" />
        <div class="text-2xl font-bold gradient-text">{{ stat.value }}</div>
        <div class="text-xs text-gray-600 mt-1">{{ stat.label }}</div>
      </div>
    </div>

    <div class="glass-effect rounded-xl p-6 mb-4">
      <h3 class="font-semibold text-gray-900 mb-4">Prochain niveau</h3>
      <div class="w-full bg-gray-200 rounded-full h-3 mb-2">
        <div
          class="bg-gradient-to-r from-primary-500 to-accent-500 h-3 rounded-full transition-all duration-1000"
          :style="{ width: `${userStore.progressToNextLevel}%` }"
        />
      </div>
      <p v-if="userStore.nextLevel" class="text-sm text-gray-600">
        {{ userStore.nextLevel.pointsRequired - userStore.user.points }} points pour débloquer le niveau {{ userStore.nextLevel.name }} 🏆
      </p>
      <p v-else class="text-sm text-gray-600">
        Niveau maximum atteint ! 🎉
      </p>
    </div>

    <button
      class="w-full py-4 bg-gradient-to-r from-primary-500 to-accent-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all hover:scale-105 active:scale-95"
    >
      Inviter des amis et gagner des points
    </button>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Gift, Users, Share2, Star } from 'lucide-vue-next'
import { useUserStore } from '@/stores/user'
import { useAuth } from '@/composables/useAuth'

const userStore = useUserStore()
const { logout } = useAuth()

const stats = computed(() => {
  const userStats = userStore.getStats()
  return [
    { icon: Gift, label: 'Deals utilisés', value: userStats.dealsUsed },
    { icon: Users, label: 'Amis invités', value: userStats.friendsInvited },
    { icon: Share2, label: 'Partages', value: userStats.shares },
    { icon: Star, label: 'Points', value: userStats.points },
  ]
})

const handleLogout = async () => {
  await logout()
}
</script>

