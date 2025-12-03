<template>
  <div class="min-h-screen px-4 py-12">
    <div class="max-w-2xl mx-auto">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-display font-bold text-gray-900 mb-2">
          Bienvenue sur LA DALLE ! 🎉
        </h1>
        <p class="text-gray-600">
          Parle-nous un peu de toi pour personnaliser ton expérience
        </p>
      </div>

      <form @submit.prevent="handleSubmit" class="glass-effect rounded-2xl p-6 space-y-6">
        <!-- Âge -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Quel âge as-tu ?
          </label>
          <input
            v-model.number="formData.age"
            type="number"
            min="13"
            max="99"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500"
            placeholder="25"
          />
        </div>

        <!-- Étudiant -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Es-tu étudiant(e) ?
          </label>
          <div class="flex gap-3">
            <button
              type="button"
              @click="formData.is_student = true"
              :class="[
                'flex-1 px-4 py-2 rounded-xl font-semibold transition border-2',
                formData.is_student
                  ? 'bg-primary-500 text-white border-primary-500'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              Oui
            </button>
            <button
              type="button"
              @click="formData.is_student = false"
              :class="[
                'flex-1 px-4 py-2 rounded-xl font-semibold transition border-2',
                !formData.is_student
                  ? 'bg-primary-500 text-white border-primary-500'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              Non
            </button>
          </div>
        </div>

        <!-- École (si étudiant) -->
        <div v-if="formData.is_student">
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Dans quelle école ? (optionnel)
          </label>
          <input
            v-model="formData.school_name"
            type="text"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500"
            placeholder="Sorbonne, Sciences Po..."
          />
        </div>

        <!-- Arrondissement -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Ton arrondissement principal ?
          </label>
          <select
            v-model="formData.main_arrondissement"
            class="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="">Sélectionne...</option>
            <option v-for="arr in arrondissements" :key="arr" :value="arr">
              {{ arr }}
            </option>
          </select>
        </div>

        <!-- Budget -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Ton budget moyen par repas ?
          </label>
          <div class="grid grid-cols-3 gap-3">
            <button
              type="button"
              v-for="budget in budgetOptions"
              :key="budget.value"
              @click="formData.budget_range = budget.value"
              :class="[
                'px-4 py-3 rounded-xl font-semibold transition border-2',
                formData.budget_range === budget.value
                  ? 'bg-primary-500 text-white border-primary-500'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              <div class="text-lg">{{ budget.value }}</div>
              <div class="text-xs">{{ budget.label }}</div>
            </button>
          </div>
        </div>

        <!-- Catégories favorites -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Tes types de cuisine préférés ?
          </label>
          <div class="grid grid-cols-2 gap-2">
            <button
              type="button"
              v-for="cat in categories"
              :key="cat.id"
              @click="toggleCategory(cat.id)"
              :class="[
                'px-4 py-2 rounded-xl font-medium transition border-2',
                formData.favorite_categories.includes(cat.id)
                  ? 'bg-primary-100 text-primary-700 border-primary-300'
                  : 'bg-white text-gray-700 border-gray-300'
              ]"
            >
              {{ cat.emoji }} {{ cat.label }}
            </button>
          </div>
        </div>

        <button
          type="submit"
          :disabled="isLoading"
          class="w-full py-3 bg-gradient-to-r from-primary-500 to-accent-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition disabled:opacity-50 hover:scale-105 active:scale-95"
        >
          <span v-if="isLoading">Enregistrement...</span>
          <span v-else>C'est parti ! 🚀</span>
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
  age: null as number | null,
  is_student: false,
  school_name: '',
  main_arrondissement: '',
  budget_range: '€€' as '€' | '€€' | '€€€',
  favorite_categories: [] as string[]
})

const arrondissements = [
  '1er', '2ème', '3ème', '4ème', '5ème', '6ème', '7ème', '8ème',
  '9ème', '10ème', '11ème', '12ème', '13ème', '14ème', '15ème',
  '16ème', '17ème', '18ème', '19ème', '20ème'
]

const budgetOptions = [
  { value: '€' as const, label: '< 15€' },
  { value: '€€' as const, label: '15-25€' },
  { value: '€€€' as const, label: '> 25€' }
]

const categories = [
  { id: 'pizza', emoji: '🍕', label: 'Pizza' },
  { id: 'burger', emoji: '🍔', label: 'Burger' },
  { id: 'sushi', emoji: '🍣', label: 'Sushi' },
  { id: 'bar', emoji: '🍻', label: 'Bar' },
  { id: 'cafe', emoji: '☕', label: 'Café' },
  { id: 'asian', emoji: '🥢', label: 'Asiatique' }
]

const toggleCategory = (catId: string) => {
  const index = formData.value.favorite_categories.indexOf(catId)
  if (index > -1) {
    formData.value.favorite_categories.splice(index, 1)
  } else {
    formData.value.favorite_categories.push(catId)
  }
}

const handleSubmit = async () => {
  if (!user.value?.id) return

  try {
    isLoading.value = true

    const { error } = await supabase.from('clients').insert({
      id: user.value.id,
      age: formData.value.age,
      is_student: formData.value.is_student,
      school_name: formData.value.school_name || null,
      main_arrondissement: formData.value.main_arrondissement || null,
      budget_range: formData.value.budget_range,
      favorite_categories: formData.value.favorite_categories
    })

    if (error) throw error

    router.push('/deals')
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error)
    alert('Erreur lors de l\'enregistrement du profil')
  } finally {
    isLoading.value = false
  }
}
</script>

