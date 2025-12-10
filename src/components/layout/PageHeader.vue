<template>
  <header class="page-header">
    <div class="header-content">
      <router-link to="/" class="logo-link">
        <img src="/logo_v2.png" alt="LA DALLE" class="logo-image" />
      </router-link>
      <h1 class="user-name body-text">{{ displayName.toUpperCase() }}</h1>
      <div v-if="user?.role === 'etudiant'" class="location-info">
        <router-link to="/addresses" class="location-link">
          <span class="location-icon">📍</span>
          <span class="location-text body-text">{{ locationDisplayText }}</span>
          <span class="chevron-icon">›</span>
        </router-link>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { useLocationStore } from '@/stores/location'

const userStore = useUserStore()
const locationStore = useLocationStore()

const user = computed(() => userStore.user)

const displayName = computed(() => {
  if (!user.value) return ''
  return user.value.username || 'Utilisateur'
})

const locationDisplayText = computed(() => {
  if (user.value?.role !== 'etudiant') return null
  
  const currentAddress = locationStore.getCurrentAddress()
  return currentAddress || 'Ajouter une adresse'
})
</script>

<style scoped>
.page-header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-bottom: 3px solid var(--black);
  padding: 1rem 80px;
  position: sticky;
  top: 0;
  z-index: 50;
  flex-shrink: 0;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.logo-link {
  display: flex;
  align-items: center;
  text-decoration: none;
  transition: transform 0.2s;
  flex-shrink: 0;
}

.logo-link:hover {
  transform: scale(1.05);
}

.logo-image {
  height: 40px;
  width: auto;
  object-fit: contain;
}

.user-name {
  font-weight: 700;
  color: var(--foreground);
  margin: 0;
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.location-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-shrink: 0;
  margin-left: auto;
}

.location-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
}

.location-link:hover {
  color: var(--primary);
}

.location-icon {
  font-size: 1rem;
}

.location-text {
  font-weight: 500;
  text-decoration: underline;
  text-decoration-color: var(--gray-500);
  text-underline-offset: 2px;
}

.chevron-icon {
  font-size: 1.2rem;
  color: var(--gray-500);
  transition: transform 0.2s, color 0.2s;
  margin-left: 0.25rem;
}

.location-link:hover .chevron-icon {
  color: var(--primary);
  transform: translateX(2px);
}

@media (max-width: 768px) {
  .header-content {
    gap: 1rem;
  }

  .logo-image {
    height: 32px;
  }

  .user-name {
    font-size: 1rem;
  }

  .location-text {
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

@media (max-width: 768px) {
  .page-header {
    padding: 0.75rem 1rem;
  }

  .header-content {
    gap: 0.75rem;
  }

  .logo-image {
    height: 28px;
  }

  .user-name {
    font-size: 0.875rem;
  }

  .location-text {
    max-width: 100px;
  }
}
</style>

