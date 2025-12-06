<template>
  <div class="home-view">
    <div class="hero">
      <img src="/logo_v2.png" alt="LA DALLE" class="hero-logo" />
      <p class="hero-subtitle">Food Deals à Paris</p>
      <p class="hero-description">1 acheté = 1 offert dans les restos/bars</p>
      <router-link to="/deals" class="cta-button">Découvrir les deals</router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.home-view {
  padding: 2rem 1rem;
  /* Supprimer min-height pour éviter les problèmes de scroll inutile */
}

.hero {
  text-align: center;
  padding: 4rem 0;
  color: white;
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
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  opacity: 0.9;
}

.hero-description {
  font-size: 1.25rem;
  margin-bottom: 2rem;
  opacity: 0.8;
}

.cta-button {
  display: inline-block;
  padding: 1rem 2rem;
  background: white;
  color: #667eea;
  text-decoration: none;
  border-radius: 50px;
  font-weight: 600;
  font-size: 1.1rem;
  transition: transform 0.2s, box-shadow 0.2s;
}

.cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
</style>

