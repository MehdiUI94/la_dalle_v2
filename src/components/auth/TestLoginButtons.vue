<template>
  <div class="glass-effect rounded-2xl p-4 mt-4 border-2 border-dashed border-gray-300">
    <p class="text-sm text-gray-700 mb-3 font-semibold">
      🧪 Connexion rapide pour tester l'app :
    </p>
    <div class="flex gap-3">
      <button
        class="flex-1 px-4 py-2 bg-primary-500 text-white rounded-xl text-sm font-semibold hover:bg-primary-600 transition hover:scale-105 active:scale-95"
        @click="handleTestClient"
      >
        👤 Client test
      </button>
      <button
        class="flex-1 px-4 py-2 bg-accent-500 text-white rounded-xl text-sm font-semibold hover:bg-accent-600 transition hover:scale-105 active:scale-95"
        @click="handleTestRestaurant"
      >
        🍕 Resto test
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuth } from '@/composables/useAuth'

const { loginTestClient, loginTestRestaurant } = useAuth()

const handleTestClient = () => {
  loginTestClient()
}

const handleTestRestaurant = () => {
  loginTestRestaurant()
}
</script>

