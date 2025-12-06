<template>
  <nav class="bottom-nav">
    <router-link to="/" class="nav-item">
      <span class="icon">🏠</span>
      <span class="label">Accueil</span>
    </router-link>
    <router-link to="/deals" class="nav-item">
      <span class="icon">🎯</span>
      <span class="label">Deals</span>
    </router-link>
    <router-link to="/map" class="nav-item">
      <span class="icon">📍</span>
      <span class="label">Carte</span>
    </router-link>
    <router-link to="/profile" class="nav-item">
      <span class="icon">👤</span>
      <span class="label">Profil</span>
    </router-link>
  </nav>
</template>

<script setup lang="ts">
</script>

<style scoped>
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-around;
  padding: 0.75rem 0;
  z-index: 100;
  flex-shrink: 0;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
  text-decoration: none;
  color: #666;
  transition: color 0.2s;
}

.nav-item.router-link-active {
  color: #667eea;
}

.icon {
  font-size: 1.5rem;
}

.label {
  font-size: 0.75rem;
  font-weight: 500;
}
</style>

