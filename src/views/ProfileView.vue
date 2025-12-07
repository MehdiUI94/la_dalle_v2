<template>
  <div class="profile-view">
    <BackButton />
    <h2 class="page-title">Mon Profil</h2>
    
    <div v-if="user" class="profile-card">
      <div class="profile-header">
        <div class="avatar">
          {{ user.username.charAt(0).toUpperCase() }}
        </div>
        <h3>{{ user.username }}</h3>
        <p class="user-email">{{ user.email }}</p>
        <span class="role-badge" :class="user.role">
          {{ user.role === 'etudiant' ? '👤 Étudiant' : '🍽️ Restaurant' }}
        </span>
      </div>

      <div class="profile-stats">
        <div class="stat-item">
          <span class="stat-label">Points</span>
          <span class="stat-value">{{ user.points }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Niveau</span>
          <span class="stat-value">{{ user.level }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Badges</span>
          <span class="stat-value">{{ user.badges.length }}</span>
        </div>
      </div>

      <div class="profile-actions">
        <button @click="handleLogout" class="logout-button">
          Se déconnecter
        </button>
      </div>
    </div>

    <div v-else class="profile-card">
      <p>Chargement du profil...</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useUserStore } from '@/stores/user'
import BackButton from '@/components/shared/BackButton.vue'

const router = useRouter()
const { logout } = useAuth()
const userStore = useUserStore()

const user = computed(() => userStore.user)

const handleLogout = async () => {
  await logout()
  router.push('/login')
}
</script>

<style scoped>
.profile-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: white;
}

.profile-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

.page-title {
  font-size: 2rem;
  margin-bottom: 2rem;
}

.profile-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.profile-header {
  text-align: center;
  margin-bottom: 2rem;
}

.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  font-weight: 700;
  color: white;
  margin: 0 auto 1rem;
}

.profile-header h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.user-email {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.role-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 50px;
  font-size: 0.85rem;
  font-weight: 600;
}

.role-badge.etudiant {
  background: rgba(102, 126, 234, 0.3);
  color: #a5b4fc;
}

.role-badge.restaurant {
  background: rgba(239, 68, 68, 0.3);
  color: #fca5a5;
}

.profile-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 0.75rem;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.stat-label {
  font-size: 0.85rem;
  color: rgba(255, 255, 255, 0.7);
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
}

.profile-actions {
  display: flex;
  justify-content: center;
}

.logout-button {
  padding: 0.875rem 2rem;
  background: rgba(239, 68, 68, 0.8);
  color: white;
  border: none;
  border-radius: 50px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
}

.logout-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(239, 68, 68, 0.4);
}

.logout-button:active {
  transform: translateY(0);
  opacity: 0.8;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
}

@media (max-width: 768px) {
  .profile-view {
    padding: 2rem 1rem;
  }
}

@media (max-width: 640px) {
  .profile-stats {
    grid-template-columns: 1fr;
  }
}
</style>



