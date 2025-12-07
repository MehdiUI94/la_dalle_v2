<template>
  <nav class="bottom-nav">
    <router-link to="/deals" class="nav-item">
      <span class="icon">🍽️</span>
      <span class="label">Mes Restos</span>
    </router-link>
    <router-link to="/map" class="nav-item">
      <span class="icon">📍</span>
      <span class="label">La Map</span>
    </router-link>
    <router-link to="/" class="nav-item home-item">
      <div class="home-circle">
        <img src="/logo_v2.png" alt="LA DALLE" class="home-logo" />
      </div>
    </router-link>
    <router-link to="/ma-dalle" class="nav-item">
      <span class="icon">⭐</span>
      <span class="label">Ma Dalle</span>
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
  background: rgba(255, 255, 255, 0.95); /* Identique au cercle */
  backdrop-filter: blur(10px); /* Identique au cercle */
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-around;
  align-items: stretch; /* Étire les éléments sur toute la hauteur */
  padding: 0; /* Pas de padding vertical */
  padding-bottom: max(0, env(safe-area-inset-bottom));
  z-index: 100;
  flex-shrink: 0;
  height: auto; /* Hauteur automatique basée sur le contenu */
  min-height: 32px; /* Hauteur minimale réduite */
  overflow: visible; /* Permet au cercle de dépasser */
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center; /* Centre les éléments verticalement */
  gap: 0.125rem; /* Gap réduit mais lisible */
  text-decoration: none;
  color: #666;
  transition: color 0.2s, transform 0.1s, opacity 0.1s, background 0.2s;
  flex: 1;
  padding: 0; /* Pas de padding */
  position: relative;
  cursor: pointer;
  align-self: stretch; /* La zone occupe toute la hauteur de la barre */
}

.nav-item:hover {
  color: #667eea;
  transform: translateY(-2px);
  background: rgba(102, 126, 234, 0.1);
}

.nav-item:active {
  transform: translateY(0);
  opacity: 0.8;
  background: rgba(102, 126, 234, 0.2);
}

.nav-item.router-link-active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.15);
}

.nav-item.home-item {
  flex: 0 0 auto;
  padding: 0;
  position: relative;
  z-index: 1;
  display: flex;
  align-items: flex-end;
  height: 100%;
  overflow: visible; /* Permet au cercle de dépasser */
}

.nav-item.home-item:hover {
  background: transparent; /* Pas de fond pour le cercle */
}

.nav-item.home-item:active {
  background: transparent; /* Pas de fond pour le cercle */
}

.home-circle {
  width: 112.5px; /* 90px * 1.25 = 112.5px */
  height: 112.5px; /* 90px * 1.25 = 112.5px */
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 3px solid rgba(50, 50, 50, 0.9); /* Gris très sombre */
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
  transition: transform 0.2s, box-shadow 0.2s;
  margin-bottom: 0; /* Le bas du cercle est aligné avec le bas de la navbar */
  margin-top: -30px; /* Descendu dans la navbar (moins de dépassement vers le haut) */
  position: relative;
  z-index: 2;
  padding: 12px;
}

.nav-item.home-item:hover .home-circle {
  transform: scale(1.05);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
}

.nav-item.home-item:active .home-circle {
  transform: scale(1.02);
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
}

.nav-item.home-item.router-link-active .home-circle {
  transform: scale(1.05);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
}

.home-logo {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
}

.icon {
  font-size: 1.25rem; /* Taille ajustée pour être proportionnelle aux labels de 14px */
  line-height: 1;
}

.label {
  font-size: 0.875rem; /* Minimum 14px (0.875rem = 14px) */
  font-weight: 500;
  text-align: center;
}

.nav-item.home-item .label {
  display: none;
}

@media (max-width: 640px) {
  .home-circle {
    width: 100px; /* 80px * 1.25 = 100px */
    height: 100px; /* 80px * 1.25 = 100px */
    margin-top: -25px; /* Descendu dans la navbar */
    padding: 10px;
    border: 3px solid rgba(50, 50, 50, 0.9); /* Gris très sombre */
    box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
  }

  .icon {
    font-size: 1.15rem; /* Taille ajustée pour être proportionnelle aux labels de 14px */
  }

  .label {
    font-size: 0.875rem; /* Minimum 14px (0.875rem = 14px) */
  }
}
</style>
