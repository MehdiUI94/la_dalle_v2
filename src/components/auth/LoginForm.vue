<template>
  <div class="glass-effect rounded-2xl p-6">
    <h2 class="text-2xl font-display font-bold text-gray-900 mb-4">
      {{ isSignup ? 'Créer un compte' : 'Se connecter' }}
    </h2>
    <p class="text-sm text-gray-600 mb-6">
      {{ isSignup ? 'Rejoins LA DALLE et découvre les meilleurs deals' : 'Content de te revoir !' }}
    </p>

    <form @submit.prevent="handleSubmit" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          Email
        </label>
        <input
          v-model="email"
          type="email"
          required
          class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="ton@email.com"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          Mot de passe
        </label>
        <input
          v-model="password"
          type="password"
          required
          :minlength="6"
          class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="••••••••"
        />
      </div>

      <div v-if="isSignup" class="space-y-3">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Je suis :
        </label>
        <div class="grid grid-cols-2 gap-3">
          <button
            type="button"
            @click="role = 'client'"
            :class="[
              'px-4 py-3 rounded-xl font-semibold transition border-2',
              role === 'client'
                ? 'bg-primary-500 text-white border-primary-500'
                : 'bg-white text-gray-700 border-gray-300 hover:border-primary-300'
            ]"
          >
            👤 Client
          </button>
          <button
            type="button"
            @click="role = 'restaurant'"
            :class="[
              'px-4 py-3 rounded-xl font-semibold transition border-2',
              role === 'restaurant'
                ? 'bg-accent-500 text-white border-accent-500'
                : 'bg-white text-gray-700 border-gray-300 hover:border-accent-300'
            ]"
          >
            🍕 Restaurant
          </button>
        </div>
      </div>

      <div v-if="errorMessage" class="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">
        {{ errorMessage }}
      </div>

      <button
        type="submit"
        :disabled="isLoading"
        class="w-full py-3 bg-gradient-to-r from-primary-500 to-accent-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition disabled:opacity-50 disabled:cursor-not-allowed hover:scale-105 active:scale-95"
      >
        <span v-if="isLoading">Chargement...</span>
        <span v-else>{{ isSignup ? 'Créer mon compte' : 'Se connecter' }}</span>
      </button>
    </form>

    <div class="mt-4 text-center">
      <button
        @click="$emit('toggle-mode')"
        class="text-sm text-gray-600 hover:text-primary-500 transition"
      >
        {{ isSignup ? 'Déjà un compte ? Se connecter' : 'Pas encore de compte ? S\'inscrire' }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useAuth } from '@/composables/useAuth'
import { useRouter } from 'vue-router'
import type { Role } from '@/types/profile'

const props = defineProps<{
  isSignup?: boolean
}>()

defineEmits<{
  'toggle-mode': []
}>()

const { login, signup, isLoading, errorMessage } = useAuth()
const router = useRouter()

const email = ref('')
const password = ref('')
const role = ref<Role>('client')

const handleSubmit = async () => {
  if (errorMessage.value) {
    errorMessage.value = null
  }

  if (props.isSignup) {
    const success = await signup(email.value, password.value, role.value)
    if (success) {
      // Rediriger vers onboarding
      if (role.value === 'client') {
        router.push('/onboarding/client')
      } else {
        router.push('/onboarding/restaurant')
      }
    }
  } else {
    // Le login redirige automatiquement selon le rôle (client → /deals, restaurant → /dashboard/restaurant)
    await login(email.value, password.value)
  }
}
</script>

