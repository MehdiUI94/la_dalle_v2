<template>
  <div class="container mx-auto px-4 py-6 pb-24">
    <!-- Hero Section -->
    <div class="text-center mb-8">
      <div class="text-6xl mb-4 animate-bounce">🎉</div>
      <h2 class="text-3xl font-display font-bold text-gray-900 mb-2">
        Sortir plutôt que commander
      </h2>
      <p class="text-gray-600 mb-6">
        Découvre les meilleurs deals "1 acheté = 1 offert" à Paris
      </p>
      <div class="flex gap-3 justify-center">
        <router-link
          to="/deals"
          class="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-primary-500 to-accent-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all hover:scale-105 active:scale-95"
        >
          Voir tous les deals
          <ArrowRight :size="20" />
        </router-link>
        <router-link
          to="/login"
          class="inline-flex items-center gap-2 px-6 py-3 bg-white text-gray-700 rounded-xl font-semibold shadow-md hover:shadow-lg transition-all hover:scale-105 active:scale-95 border-2 border-gray-200"
        >
          Se connecter
        </router-link>
      </div>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-3 gap-4 mb-8">
      <div
        v-for="(stat, i) in stats"
        :key="stat.label"
        class="glass-effect rounded-xl p-4 text-center"
        :style="{ animationDelay: `${i * 0.1}s` }"
      >
        <div class="text-2xl font-bold gradient-text">{{ stat.value }}</div>
        <div class="text-xs text-gray-600 mt-1">{{ stat.label }}</div>
      </div>
    </div>

    <!-- Featured Deals -->
    <div class="mb-6">
      <div class="flex items-center gap-2 mb-4">
        <Sparkles class="text-primary-500" :size="20" />
        <h3 class="text-xl font-display font-bold text-gray-900">
          Deals du moment
        </h3>
      </div>
      <DealList :deals="featuredDeals" />
    </div>

    <!-- CTA -->
    <div class="glass-effect rounded-2xl p-6 text-center">
      <h3 class="font-display font-bold text-xl mb-2">
        Invite tes potes et gagne des deals exclusifs ! 🎁
      </h3>
      <p class="text-sm text-gray-600 mb-4">
        Plus tu invites, plus tu débloques de deals premium
      </p>
      <button
        class="px-6 py-2 bg-accent-500 text-white rounded-xl font-semibold hover:bg-accent-600 transition-colors hover:scale-105 active:scale-95"
      >
        Inviter des amis
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ArrowRight, Sparkles } from 'lucide-vue-next'
import DealList from '@/components/deals/DealList.vue'
import { useDeals } from '@/composables/useDeals'

const { featuredDeals } = useDeals()

const stats = [
  { label: 'Restos', value: '150+' },
  { label: 'Deals', value: '200+' },
  { label: 'Users', value: '5K+' },
]
</script>

