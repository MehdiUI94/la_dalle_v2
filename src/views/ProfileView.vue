<template>
  <div class="profile-view">
    <h2 class="page-title">Mon Profil</h2>
    <div class="profile-card">
      <p>Connectez-vous pour voir votre profil</p>
      <router-link to="/login" class="login-link">Se connecter</router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.profile-view {
  padding: 2rem 1rem;
  min-height: calc(100vh - 140px);
  color: white;
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
  text-align: center;
}

.login-link {
  display: inline-block;
  margin-top: 1rem;
  padding: 0.75rem 1.5rem;
  background: white;
  color: #667eea;
  text-decoration: none;
  border-radius: 50px;
  font-weight: 600;
}
</style>

