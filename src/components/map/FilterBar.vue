<template>
  <div class="filters-row">
      <!-- Filtres actifs -->
      <div
        v-for="(activeFilter, index) in activeFilters"
        :key="`${activeFilter.type}-${index}`"
        class="active-filter-item"
      >
        <div class="filter-content">
          <span class="filter-type-label">{{ getFilterLabelForType(activeFilter.type) }}</span>
          
          <!-- Rating Select -->
          <select
            v-if="activeFilter.type === 'rating'"
            v-model="activeFilter.value"
            @change="updateFilterValue(index, activeFilter.value)"
            class="filter-input-select"
          >
            <option :value="null">Toutes</option>
            <option :value="4">4+ ⭐</option>
            <option :value="4.5">4.5+ ⭐</option>
            <option :value="5">5 ⭐</option>
          </select>

          <!-- Distance Select -->
          <select
            v-else-if="activeFilter.type === 'distance'"
            v-model="activeFilter.value"
            @change="updateFilterValue(index, activeFilter.value)"
            class="filter-input-select"
          >
            <option :value="null">Toutes</option>
            <option :value="1">1 km</option>
            <option :value="2">2 km</option>
            <option :value="5">5 km</option>
            <option :value="10">10 km</option>
          </select>

          <!-- Promos Checkbox -->
          <label
            v-else-if="activeFilter.type === 'promos'"
            class="filter-checkbox-label-inline"
          >
            <input
              v-model="activeFilter.value"
              @change="updateFilterValue(index, activeFilter.value)"
              type="checkbox"
              class="filter-input-checkbox"
            />
            <span>Avec promos</span>
          </label>

          <!-- Favorites Checkbox -->
          <label
            v-else-if="activeFilter.type === 'favorites'"
            class="filter-checkbox-label-inline"
          >
            <input
              v-model="activeFilter.value"
              @change="updateFilterValue(index, activeFilter.value)"
              type="checkbox"
              class="filter-input-checkbox"
            />
            <span>Mes favoris</span>
          </label>

          <!-- Food Type Select -->
          <select
            v-else-if="activeFilter.type === 'foodType'"
            v-model="activeFilter.value"
            @change="updateFilterValue(index, activeFilter.value)"
            class="filter-input-select"
          >
            <option :value="null">Tous</option>
            <option value="pizza">🍕 Pizza</option>
            <option value="burger">🍔 Burger</option>
            <option value="sushi">🍣 Sushi</option>
            <option value="italien">🍝 Italien</option>
            <option value="asiatique">🍜 Asiatique</option>
            <option value="francais">🥖 Français</option>
            <option value="mexicain">🌮 Mexicain</option>
            <option value="vegetarien">🥗 Végétarien</option>
            <option value="vegan">🌱 Vegan</option>
          </select>

          <!-- Diet Select -->
          <select
            v-else-if="activeFilter.type === 'diet'"
            v-model="activeFilter.value"
            @change="updateFilterValue(index, activeFilter.value)"
            class="filter-input-select"
          >
            <option :value="null">Tous</option>
            <option value="vegetarien">🥗 Végétarien</option>
            <option value="vegan">🌱 Vegan</option>
            <option value="sans-gluten">🌾 Sans gluten</option>
            <option value="halal">🕌 Halal</option>
            <option value="casher">✡️ Casher</option>
          </select>
        </div>
        <button @click="removeFilter(index)" class="remove-filter-button" aria-label="Supprimer le filtre">
          ×
        </button>
      </div>

      <!-- Menu déroulant pour ajouter un nouveau filtre -->
      <div class="add-filter-container">
        <select
          v-model="selectedFilterToAdd"
          class="add-filter-select"
          @change="addFilter"
        >
          <option :value="null">Ajouter un filtre</option>
          <option
            v-for="filter in availableFilters"
            :key="filter.type"
            :value="filter.type"
          >
            {{ filter.label }}
          </option>
        </select>
      </div>
    </div>

    <!-- Bouton réinitialiser -->
    <div v-if="activeFilters.length > 0" class="filter-actions">
      <button @click="resetAllFilters" class="reset-button">
        Réinitialiser tous les filtres
      </button>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

export interface FilterOptions {
  minRating: number | null
  maxDistance: number | null
  hasPromos: boolean
  favoritesOnly: boolean
  foodType: string | null
  diet: string | null
}

interface ActiveFilter {
  type: string
  value: any
}

interface FilterDefinition {
  type: string
  label: string
  component: string
  defaultValue: any
}

const props = defineProps<{
  modelValue: FilterOptions
}>()

const emit = defineEmits<{
  'update:modelValue': [value: FilterOptions]
}>()

const activeFilters = ref<ActiveFilter[]>([])
const selectedFilterToAdd = ref<string | null>(null)

const filterDefinitions: FilterDefinition[] = [
  {
    type: 'rating',
    label: 'Note minimum',
    component: 'rating-select',
    defaultValue: null
  },
  {
    type: 'distance',
    label: 'Distance maximum',
    component: 'distance-select',
    defaultValue: null
  },
  {
    type: 'promos',
    label: 'Avec promos',
    component: 'promos-checkbox',
    defaultValue: false
  },
  {
    type: 'favorites',
    label: 'Mes favoris',
    component: 'favorites-checkbox',
    defaultValue: false
  },
  {
    type: 'foodType',
    label: 'Type de nourriture',
    component: 'food-type-select',
    defaultValue: null
  },
  {
    type: 'diet',
    label: 'Régime alimentaire',
    component: 'diet-select',
    defaultValue: null
  }
]

// Filtres disponibles (non encore ajoutés)
const availableFilters = computed(() => {
  const activeTypes = activeFilters.value.map(f => f.type)
  return filterDefinitions.filter(f => !activeTypes.includes(f.type))
})

// Fonction pour obtenir les filtres depuis les filtres actifs
const getFiltersFromActiveFilters = (): FilterOptions => {
  const options: FilterOptions = {
    minRating: null,
    maxDistance: null,
    hasPromos: false,
    favoritesOnly: false,
    foodType: null,
    diet: null
  }

  activeFilters.value.forEach(filter => {
    switch (filter.type) {
      case 'rating':
        options.minRating = filter.value
        break
      case 'distance':
        options.maxDistance = filter.value
        break
      case 'promos':
        options.hasPromos = filter.value
        break
      case 'favorites':
        options.favoritesOnly = filter.value
        break
      case 'foodType':
        options.foodType = filter.value
        break
      case 'diet':
        options.diet = filter.value
        break
    }
  })

  return options
}

// Synchroniser les filtres actifs avec les props
watch(() => props.modelValue, (newValue) => {
  // Éviter les boucles infinies en vérifiant si les filtres ont vraiment changé
  const currentFilters = getFiltersFromActiveFilters()
  if (JSON.stringify(currentFilters) !== JSON.stringify(newValue)) {
    syncFiltersFromProps(newValue)
  }
}, { deep: true, immediate: true })

// Émettre les changements vers le parent
watch(activeFilters, () => {
  emitFiltersToParent()
}, { deep: true })

const syncFiltersFromProps = (options: FilterOptions) => {
  const newActiveFilters: ActiveFilter[] = []
  
  if (options.minRating !== null) {
    newActiveFilters.push({ type: 'rating', value: options.minRating })
  }
  if (options.maxDistance !== null) {
    newActiveFilters.push({ type: 'distance', value: options.maxDistance })
  }
  if (options.hasPromos) {
    newActiveFilters.push({ type: 'promos', value: true })
  }
  if (options.favoritesOnly) {
    newActiveFilters.push({ type: 'favorites', value: true })
  }
  if (options.foodType !== null) {
    newActiveFilters.push({ type: 'foodType', value: options.foodType })
  }
  if (options.diet !== null) {
    newActiveFilters.push({ type: 'diet', value: options.diet })
  }

  activeFilters.value = newActiveFilters
}

const emitFiltersToParent = () => {
  const options: FilterOptions = {
    minRating: null,
    maxDistance: null,
    hasPromos: false,
    favoritesOnly: false,
    foodType: null,
    diet: null
  }

  activeFilters.value.forEach(filter => {
    switch (filter.type) {
      case 'rating':
        options.minRating = filter.value
        break
      case 'distance':
        options.maxDistance = filter.value
        break
      case 'promos':
        options.hasPromos = filter.value
        break
      case 'favorites':
        options.favoritesOnly = filter.value
        break
      case 'foodType':
        options.foodType = filter.value
        break
      case 'diet':
        options.diet = filter.value
        break
    }
  })

  emit('update:modelValue', options)
}

const addFilter = () => {
  if (!selectedFilterToAdd.value) return

  const filterDef = filterDefinitions.find(f => f.type === selectedFilterToAdd.value)
  if (filterDef) {
    activeFilters.value.push({
      type: filterDef.type,
      value: filterDef.defaultValue
    })
    // Réinitialiser le select après ajout
    selectedFilterToAdd.value = null
  }
}

const removeFilter = (index: number) => {
  activeFilters.value.splice(index, 1)
}

const updateFilterValue = (index: number, value: any) => {
  if (activeFilters.value[index]) {
    activeFilters.value[index].value = value
  }
}

const resetAllFilters = () => {
  activeFilters.value = []
  selectedFilterToAdd.value = null
}

const getFilterLabelForType = (type: string): string => {
  const filterDef = filterDefinitions.find(f => f.type === type)
  return filterDef?.label || type
}
</script>

<style scoped>
.filters-row {
  margin-bottom: 1.5rem;
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: stretch;
}

.active-filter-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: var(--background);
  border: 2px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  padding: 0.5rem 0.75rem;
  min-height: 60px;
}

.filter-content {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex: 1;
}

.filter-type-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--foreground);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.remove-filter-button {
  background: var(--background);
  border: 2px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  color: var(--foreground);
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 1.25rem;
  font-weight: 600;
  line-height: 1;
  transition: all 0.2s;
  flex-shrink: 0;
}

.remove-filter-button:hover {
  transform: translate(-2px, -2px);
  box-shadow: 4px 4px 0 0 var(--black);
}

.remove-filter-button:active {
  transform: translate(0, 0);
  box-shadow: 2px 2px 0 0 var(--black);
}

.add-filter-container {
}

.add-filter-select {
  width: 100%;
  padding: 0.5rem 0.75rem;
  border: 2px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  background: var(--background);
  color: var(--foreground);
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
}

.add-filter-select:focus {
  outline: none;
  transform: translate(-2px, -2px);
  box-shadow: 4px 4px 0 0 var(--black);
}

.add-filter-select option {
  background: var(--background);
  color: var(--foreground);
}

.filter-actions {
  margin-top: 1rem;
  margin-bottom: 40px;
  display: flex;
  justify-content: center;
}

.reset-button {
  padding: 0.5rem 1rem;
  background: var(--primary);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  color: var(--background);
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.reset-button:hover {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.reset-button:active {
  transform: translate(0, 0);
  box-shadow: 4px 4px 0 0 var(--black);
}

.filter-input-select {
  padding: 0.5rem 0.75rem;
  border: 2px solid var(--black);
  background: var(--background);
  box-shadow: 2px 2px 0 0 var(--black);
  color: var(--foreground);
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
  width: 100%;
}

.filter-input-select:focus {
  outline: none;
  transform: translate(-2px, -2px);
  box-shadow: 4px 4px 0 0 var(--black);
}

.filter-input-select option {
  background: var(--background);
  color: var(--foreground);
}

.filter-checkbox-label-inline {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  color: var(--foreground);
}

.filter-input-checkbox {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--primary);
}

@media (max-width: 768px) {
  .filters-row {
    flex-direction: column;
  }

  .active-filter-item,
  .add-filter-container {
    width: 100%;
  }
}
</style>
