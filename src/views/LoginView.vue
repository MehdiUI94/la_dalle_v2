<template>
  <div class="min-h-screen flex items-center justify-center px-4 py-12">
    <div class="w-full max-w-md">
      <div class="text-center mb-8">
        <h1 class="text-4xl font-display font-bold gradient-text mb-2">
          🍕 LA DALLE
        </h1>
        <p class="text-gray-600">
          1 acheté = 1 offert dans les meilleurs spots de Paris
        </p>
      </div>

      <LoginForm :is-signup="isSignup" @toggle-mode="toggleMode" />

      <TestLoginButtons />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import LoginForm from '@/components/auth/LoginForm.vue'
import TestLoginButtons from '@/components/auth/TestLoginButtons.vue'

const isSignup = ref(false)

const toggleMode = () => {
  isSignup.value = !isSignup.value
}
</script>

