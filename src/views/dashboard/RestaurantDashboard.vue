<template>
  <div class="container mx-auto px-4 py-6 pb-24">
    <div class="mb-6">
      <h1 class="text-2xl font-display font-bold text-gray-900 mb-2">
        Dashboard Restaurant 🍕
      </h1>
      <p class="text-gray-600">Gère ton profil et tes deals</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-3 gap-4 mb-6">
      <div class="glass-effect rounded-xl p-4 text-center">
        <div class="text-2xl font-bold gradient-text">5</div>
        <div class="text-xs text-gray-600 mt-1">Deals actifs</div>
      </div>
      <div class="glass-effect rounded-xl p-4 text-center">
        <div class="text-2xl font-bold gradient-text">127</div>
        <div class="text-xs text-gray-600 mt-1">Vues ce mois</div>
      </div>
      <div class="glass-effect rounded-xl p-4 text-center">
        <div class="text-2xl font-bold gradient-text">42</div>
        <div class="text-xs text-gray-600 mt-1">Deals utilisés</div>
      </div>
    </div>

    <!-- Actions rapides -->
    <div class="glass-effect rounded-2xl p-6 mb-6">
      <h2 class="font-semibold text-lg mb-4">Actions rapides</h2>
      <div class="grid grid-cols-2 gap-3">
        <button class="px-4 py-3 bg-accent-500 text-white rounded-xl font-semibold hover:bg-accent-600 transition">
          ➕ Créer un deal
        </button>
        <button class="px-4 py-3 bg-gray-100 text-gray-700 rounded-xl font-semibold hover:bg-gray-200 transition">
          ⚙️ Modifier profil
        </button>
      </div>
    </div>

    <!-- Liste des deals (placeholder) -->
    <div class="glass-effect rounded-2xl p-6">
      <h2 class="font-semibold text-lg mb-4">Mes deals</h2>
      <p class="text-gray-500 text-center py-8">
        Aucun deal pour le moment. Crée ton premier deal !
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

