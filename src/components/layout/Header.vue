<template>
  <header class="header">
    <div class="header-content">
      <router-link to="/" class="logo-link">
        <img src="/logo_v2.png" alt="LA DALLE" class="logo-image" />
      </router-link>
      <div class="header-actions">
        <router-link v-if="!isAuthenticated" to="/login" class="action-button login">
          Connexion
        </router-link>
        <router-link v-if="!isAuthenticated" to="/signup" class="action-button signup">
          Inscription
        </router-link>
        <router-link v-if="isAuthenticated" to="/profile" class="action-button profile">
          Mon Profil
        </router-link>
        <button v-if="isAuthenticated" @click="handleLogout" class="action-button logout">
          Déconnexion
        </button>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const { isAuthenticated: checkAuth, logout } = useAuth()
const router = useRouter()

const isAuthenticated = computed(() => checkAuth())

const handleLogout = async () => {
  await logout()
  router.push('/')
}
</script>

<style scoped>
.header {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  padding: 1rem 0;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  flex-shrink: 0;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo-link {
  text-decoration: none;
  display: flex;
  align-items: center;
}

.logo-image {
  height: 40px;
  width: auto;
  object-fit: contain;
  transition: transform 0.2s;
}

.logo-link:hover .logo-image {
  transform: scale(1.05);
}

.header-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.action-button {
  padding: 0.5rem 1.25rem;
  border-radius: 50px;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9rem;
  transition: transform 0.2s, box-shadow 0.2s;
  border: none;
  cursor: pointer;
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.action-button.login {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.action-button.signup {
  background: white;
  color: #667eea;
}

.action-button.profile {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.action-button.logout {
  background: rgba(239, 68, 68, 0.8);
  color: white;
}
</style>

