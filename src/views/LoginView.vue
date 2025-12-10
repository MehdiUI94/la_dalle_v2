<template>
  <div class="login-view">
    <div class="login-container">
      <img src="/logo_v2.png" alt="LA DALLE" class="logo-image" />
      <div class="login-card">
        <h2 class="section-title">CONNEXION</h2>
        
        <!-- Choix du type d'utilisateur avec tabs -->
        <div class="tabs-container">
          <div class="tabs">
            <button
              @click="selectedRole = 'etudiant'"
              :class="['tab', { active: selectedRole === 'etudiant' }]"
            >
              👤 Étudiant
            </button>
            <button
              @click="selectedRole = 'restaurant'"
              :class="['tab', { active: selectedRole === 'restaurant' }]"
            >
              🍽️ Restaurant
            </button>
          </div>
        </div>

        <!-- Formulaire de connexion -->
        <form @submit.prevent="handleLogin" class="login-form">
          <div class="form-group">
            <label for="email">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              placeholder="Votre@email.com"
              required
              autocomplete="email"
              class="form-field"
            />
          </div>

          <div class="form-group">
            <label for="password">Mot de passe</label>
            <input
              id="password"
              v-model="password"
              type="password"
              placeholder="••••••••"
              required
              class="form-field"
              autocomplete="current-password"
            />
          </div>

          <div v-if="errorMessage" class="error-message">
            {{ errorMessage }}
          </div>

          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Connexion...</span>
            <span v-else>Se connecter</span>
          </button>
        </form>

        <div class="divider">
          <span>ou</span>
        </div>

        <!-- Boutons de test -->
        <div class="test-buttons">
          <button @click="handleTestClient" class="test-button etudiant">
            Connexion Étudiant Test
          </button>
          <button @click="handleTestRestaurant" class="test-button restaurant">
            Connexion Restaurant Test
          </button>
        </div>

        <p class="signup-link">
          Pas encore de compte ? 
          <router-link to="/signup">Inscrivez-vous</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import type { Role } from '@/types/profile'

const router = useRouter()
const { login, loginTestClient, loginTestRestaurant, isLoading, errorMessage } = useAuth()

const selectedRole = ref<Role>('etudiant')
const email = ref('')
const password = ref('')

const handleLogin = async () => {
  const success = await login(email.value, password.value)
  if (success) {
    // Rediriger selon le rôle de l'utilisateur
    const userRole = localStorage.getItem('la_dalle_user') 
      ? JSON.parse(localStorage.getItem('la_dalle_user')!).role 
      : selectedRole.value
    if (userRole === 'etudiant') {
      router.push('/')
    } else {
      router.push('/dashboard/restaurant')
    }
  }
}

const handleTestClient = async () => {
  await loginTestClient()
  router.push('/')
}

const handleTestRestaurant = async () => {
  await loginTestRestaurant()
  router.push('/dashboard/restaurant')
}
</script>

<style scoped>
.login-view {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem 80px;
  color: var(--foreground);
  position: relative;
}

.login-container {
  width: 100%;
  max-width: 450px;
}

.logo-image {
  height: 80px;
  width: auto;
  object-fit: contain;
  margin-bottom: 2rem;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.login-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.login-card h2 {
  margin-bottom: 1.5rem;
  text-align: center;
}

.tabs-container {
  margin-bottom: 1.5rem;
}

.tabs {
  display: flex;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  padding: 0.25rem;
  gap: 0.25rem;
}

.tab {
  flex: 1;
  padding: 0.75rem 1rem;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.7);
  border-radius: 0.375rem;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.tab:hover {
  color: var(--foreground);
  background: rgba(255, 255, 255, 0.1);
}

.tab:active {
  opacity: 0.7;
  transform: scale(0.98);
}

.tab.active {
  background: white;
  color: var(--primary);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
  font-size: 0.9rem;
}

.form-group input {
  /* Utilise les classes form-field définies dans style.css */
}

.error-message {
  padding: 0.75rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  border-radius: 0.5rem;
  color: #ffcccc;
  font-size: 0.9rem;
  text-align: center;
}

.submit-button {
  padding: 0.875rem;
  background: var(--primary);
  color: var(--background);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
  margin-top: 0.5rem;
}

.submit-button:hover:not(:disabled) {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.submit-button:active:not(:disabled) {
  transform: translate(0, 0);
  opacity: 0.8;
  box-shadow: 4px 4px 0 0 var(--black);
}

.submit-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.divider {
  display: flex;
  align-items: center;
  margin: 1.5rem 0;
  text-align: center;
}

.divider::before,
.divider::after {
  content: '';
  flex: 1;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.divider span {
  padding: 0 1rem;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.test-buttons {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.test-button {
  padding: 0.75rem;
  border: none;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
}

.test-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.test-button:active {
  transform: translateY(0);
  opacity: 0.8;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.test-button.etudiant {
  background: var(--primary);
  color: var(--foreground);
}

.test-button.restaurant {
  background: #ef4444;
  color: var(--foreground);
}

.signup-link {
  margin-top: 1.5rem;
  text-align: center;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.8);
}

.signup-link a {
  color: var(--foreground);
  font-weight: 600;
  text-decoration: underline;
}

@media (max-width: 768px) {
  .login-view {
    padding: 2rem 1rem;
  }
}
</style>
