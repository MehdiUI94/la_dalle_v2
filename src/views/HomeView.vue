<template>
  <div class="home-view">
    <div class="hero">
      <img src="/logo_v2.png" alt="LA DALLE" class="hero-logo" />
      <h1 class="hero-title">LA DALLE</h1>
      <p class="hero-subtitle body-text">Food Deals à Paris</p>
      <p class="hero-description body-text">1 acheté = 1 offert dans les restos/bars</p>
      <router-link to="/deals" class="cta-button">Découvrir les deals</router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.home-view {
  padding: 2rem 80px;
  /* Supprimer min-height pour éviter les problèmes de scroll inutile */
}

.hero {
  text-align: center;
  padding: 4rem 0;
  color: var(--foreground);
}

.hero-logo {
  height: 120px;
  width: auto;
  object-fit: contain;
  margin-bottom: 1rem;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.hero-subtitle {
  margin-bottom: 0.5rem;
  opacity: 0.9;
  font-weight: 500;
}

.hero-description {
  margin-bottom: 2rem;
  opacity: 0.8;
}

.cta-button {
  display: inline-block;
  padding: 1rem 2rem;
  background: var(--primary);
  color: var(--background);
  text-decoration: none;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
}

.cta-button:hover {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.cta-button:active {
  transform: translate(0, 0);
  opacity: 0.8;
  box-shadow: 4px 4px 0 0 var(--black);
}

@media (max-width: 768px) {
  .home-view {
    padding: 2rem 1rem;
  }
}
</style>

