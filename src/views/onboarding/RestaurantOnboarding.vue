<template>
  <div class="min-h-screen px-4 py-12">
    <div class="max-w-2xl mx-auto">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-display font-bold text-gray-900 mb-2">
          Bienvenue partenaire ! 🍕
        </h1>
        <p class="text-gray-600">
          Crée ton profil resto et tes premiers deals
        </p>
      </div>

      <form @submit.prevent="handleSubmit" class="glass-effect rounded-2xl p-6 space-y-6">
        <!-- Nom du restaurant -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Nom du restaurant *
          </label>
          <input
            v-model="formData.name"
            type="text"
            required
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
            placeholder="Pizza Paradise"
          />
        </div>

        <!-- Description -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Description
          </label>
          <textarea
            v-model="formData.description"
            rows="3"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
            placeholder="Pizzas artisanales au feu de bois..."
          />
        </div>

        <!-- Adresse -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Adresse *
          </label>
          <input
            v-model="formData.address"
            type="text"
            required
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
            placeholder="123 rue de la Paix, 75001 Paris"
          />
        </div>

        <!-- Arrondissement -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Arrondissement *
          </label>
          <select
            v-model="formData.arrondissement"
            required
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
          >
            <option value="">Sélectionne...</option>
            <option v-for="arr in arrondissements" :key="arr" :value="arr">
              {{ arr }}
            </option>
          </select>
        </div>

        <!-- Téléphone -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Téléphone
          </label>
          <input
            v-model="formData.phone"
            type="tel"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
            placeholder="01 23 45 67 89"
          />
        </div>

        <!-- Instagram -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Instagram (optionnel)
          </label>
          <input
            v-model="formData.instagram"
            type="text"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-accent-500"
            placeholder="@tonresto"
          />
        </div>

        <!-- Gamme de prix -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Gamme de prix
          </label>
          <div class="grid grid-cols-3 gap-3">
            <button
              type="button"
              v-for="price in priceOptions"
              :key="price.value"
              @click="formData.price_level = price.value"
              :class="[
                'px-4 py-3 rounded-xl font-semibold transition border-2',
                formData.price_level === price.value
                  ? 'bg-accent-500 text-white border-accent-500'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              <div class="text-lg">{{ price.value }}</div>
              <div class="text-xs">{{ price.label }}</div>
            </button>
          </div>
        </div>

        <!-- Types de cuisine -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Type(s) de cuisine
          </label>
          <div class="grid grid-cols-2 gap-2">
            <button
              type="button"
              v-for="cuisine in cuisineTypes"
              :key="cuisine.id"
              @click="toggleCuisine(cuisine.id)"
              :class="[
                'px-4 py-2 rounded-xl font-medium transition border-2',
                formData.cuisine_types.includes(cuisine.id)
                  ? 'bg-accent-100 text-accent-700 border-accent-300'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              {{ cuisine.emoji }} {{ cuisine.label }}
            </button>
          </div>
        </div>

        <!-- Student friendly -->
        <div class="flex items-center gap-3">
          <input
            v-model="formData.is_student_friendly"
            type="checkbox"
            id="student-friendly"
            class="w-5 h-5 text-accent-500 border-gray-300 rounded focus:ring-accent-500"
          />
          <label for="student-friendly" class="text-sm text-gray-700">
            Mon resto est étudiant-friendly 🎓
          </label>
        </div>

        <button
          type="submit"
          :disabled="isLoading"
          class="w-full py-3 bg-gradient-to-r from-accent-500 to-primary-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition disabled:opacity-50 hover:scale-105 active:scale-95"
        >
          <span v-if="isLoading">Enregistrement...</span>
          <span v-else>Créer mon profil resto 🚀</span>
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabaseClient'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const { user } = useAuth()
const isLoading = ref(false)

const formData = ref({
  name: '',
  description: '',
  address: '',
  arrondissement: '',
  phone: '',
  instagram: '',
  price_level: '€€' as '€' | '€€' | '€€€',
  cuisine_types: [] as string[],
  is_student_friendly: true
})

const arrondissements = [
  '1er', '2ème', '3ème', '4ème', '5ème', '6ème', '7ème', '8ème',
  '9ème', '10ème', '11ème', '12ème', '13ème', '14ème', '15ème',
  '16ème', '17ème', '18ème', '19ème', '20ème'
]

const priceOptions = [
  { value: '€' as const, label: 'Économique' },
  { value: '€€' as const, label: 'Moyen' },
  { value: '€€€' as const, label: 'Premium' }
]

const cuisineTypes = [
  { id: 'pizza', emoji: '🍕', label: 'Pizza' },
  { id: 'burger', emoji: '🍔', label: 'Burger' },
  { id: 'sushi', emoji: '🍣', label: 'Sushi' },
  { id: 'french', emoji: '🥖', label: 'Français' },
  { id: 'italian', emoji: '🍝', label: 'Italien' },
  { id: 'asian', emoji: '🥢', label: 'Asiatique' }
]

const toggleCuisine = (cuisineId: string) => {
  const index = formData.value.cuisine_types.indexOf(cuisineId)
  if (index > -1) {
    formData.value.cuisine_types.splice(index, 1)
  } else {
    formData.value.cuisine_types.push(cuisineId)
  }
}

const handleSubmit = async () => {
  if (!user.value?.id) return

  try {
    isLoading.value = true

    const { error } = await supabase.from('restaurants').insert({
      id: user.value.id,
      name: formData.value.name,
      description: formData.value.description || null,
      address: formData.value.address,
      arrondissement: formData.value.arrondissement,
      phone: formData.value.phone || null,
      instagram: formData.value.instagram || null,
      price_level: formData.value.price_level,
      cuisine_types: formData.value.cuisine_types,
      is_student_friendly: formData.value.is_student_friendly
    })

    if (error) throw error

    router.push('/dashboard/restaurant')
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error)
    alert('Erreur lors de l\'enregistrement du profil')
  } finally {
    isLoading.value = false
  }
}
</script>

