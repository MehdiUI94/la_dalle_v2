<template>
  <div class="address-autocomplete">
    <label :for="inputId">{{ label }} <span v-if="required" class="asterisk">*</span></label>
    
    <div class="autocomplete-wrapper">
      <input
        :id="inputId"
        ref="inputRef"
        v-model="searchQuery"
        type="text"
        :placeholder="placeholder"
        :required="required"
        autocomplete="off"
        :class="{ 'invalid-address': searchQuery && !isValidAddress }"
        @input="handleInput"
        @focus="showSuggestions = true"
        @blur="handleBlur"
        @keydown.arrow-down.prevent="navigateSuggestions(1)"
        @keydown.arrow-up.prevent="navigateSuggestions(-1)"
        @keydown.enter.prevent="selectSuggestion(selectedIndex >= 0 ? selectedIndex : 0)"
      />
      
      <div v-if="isLoading" class="loading-indicator">
        <div class="spinner-small"></div>
      </div>

      <ul
        v-if="showSuggestions && suggestions.length > 0"
        class="suggestions-list"
        ref="suggestionsRef"
      >
        <li
          v-for="(suggestion, index) in suggestions"
          :key="index"
          :class="['suggestion-item', { active: index === selectedIndex }]"
          @mousedown.prevent="selectSuggestion(index)"
          @mouseenter="selectedIndex = index"
        >
          <span class="suggestion-label">{{ suggestion.label }}</span>
          <span class="suggestion-city">{{ suggestion.city }} {{ suggestion.postcode }}</span>
        </li>
      </ul>

      <p v-if="error" class="error-message">{{ error }}</p>
      <p v-if="searchQuery && !isValidAddress && !isLoading && suggestions.length === 0 && searchQuery.length >= 3" class="error-message">
        Veuillez sélectionner une adresse dans la liste
      </p>
      <p v-if="searchQuery && !isValidAddress && !isLoading && showSuggestions && suggestions.length > 0" class="warning-message">
        Sélectionnez une adresse dans la liste ci-dessous
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from 'vue'
import { useAddressAutocomplete } from '@/composables/useAddressAutocomplete'

interface Props {
  modelValue: string
  label: string
  inputId: string
  placeholder?: string
  required?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Commencez à taper une adresse...',
  required: false
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
  'validation-change': [isValid: boolean]
}>()

defineExpose({
  isValid: () => isValidAddress.value,
  getValue: () => searchQuery.value
})

const inputRef = ref<HTMLInputElement | null>(null)
const suggestionsRef = ref<HTMLElement | null>(null)
const searchQuery = ref(props.modelValue)
const showSuggestions = ref(false)
const selectedIndex = ref(-1)
const isValidAddress = ref(false)
const selectedAddressId = ref<string | null>(null)

const { suggestions, isLoading, error, searchAddresses } = useAddressAutocomplete()

let searchTimeout: ReturnType<typeof setTimeout> | null = null

const handleInput = () => {
  isValidAddress.value = false
  selectedAddressId.value = null
  emit('validation-change', false)
  
  if (searchTimeout) {
    clearTimeout(searchTimeout)
  }

  searchTimeout = setTimeout(() => {
    if (searchQuery.value.length >= 3) {
      searchAddresses(searchQuery.value)
      selectedIndex.value = -1
    } else {
      suggestions.value = []
      if (searchQuery.value.length > 0) {
        isValidAddress.value = false
        emit('validation-change', false)
      }
    }
  }, 300)
  
  emit('update:modelValue', searchQuery.value)
}

const handleBlur = () => {
  setTimeout(() => {
    showSuggestions.value = false
  }, 200)
}

const navigateSuggestions = (direction: number) => {
  if (suggestions.value.length === 0) return

  selectedIndex.value += direction

  if (selectedIndex.value < 0) {
    selectedIndex.value = suggestions.value.length - 1
  } else if (selectedIndex.value >= suggestions.value.length) {
    selectedIndex.value = 0
  }

  nextTick(() => {
    const activeItem = suggestionsRef.value?.children[selectedIndex.value] as HTMLElement
    if (activeItem) {
      activeItem.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  })
}

const selectSuggestion = (index: number) => {
  if (index >= 0 && index < suggestions.value.length) {
    const suggestion = suggestions.value[index]
    searchQuery.value = suggestion.value
    isValidAddress.value = true
    selectedAddressId.value = suggestion.id
    emit('update:modelValue', suggestion.value)
    emit('validation-change', true)
    showSuggestions.value = false
    selectedIndex.value = -1
  }
}

watch(() => props.modelValue, (newValue) => {
  if (newValue !== searchQuery.value) {
    searchQuery.value = newValue
    const match = suggestions.value.find(s => s.value === newValue)
    if (match) {
      isValidAddress.value = true
      selectedAddressId.value = match.id
      emit('validation-change', true)
    } else if (newValue) {
      isValidAddress.value = false
      selectedAddressId.value = null
      emit('validation-change', false)
    }
  }
})

watch(() => suggestions.value, (newSuggestions) => {
  if (searchQuery.value && newSuggestions.length > 0) {
    const exactMatch = newSuggestions.find(s => s.value === searchQuery.value)
    if (exactMatch) {
      isValidAddress.value = true
      selectedAddressId.value = exactMatch.id
      emit('validation-change', true)
    }
  }
})
</script>

<style scoped>
.address-autocomplete {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: relative;
}

.autocomplete-wrapper {
  position: relative;
}

.autocomplete-wrapper input {
  width: 100%;
  padding: 0.75rem;
  padding-right: 2.5rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  color: white;
  font-size: 1rem;
  font-family: inherit;
}

.autocomplete-wrapper input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.autocomplete-wrapper input:focus {
  outline: none;
  border-color: white;
  background: rgba(255, 255, 255, 0.15);
}

.autocomplete-wrapper input.invalid-address {
  border-color: rgba(239, 68, 68, 0.5);
  background: rgba(239, 68, 68, 0.1);
}

.loading-indicator {
  position: absolute;
  right: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none;
}

.spinner-small {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.suggestions-list {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 0.25rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  max-height: 300px;
  overflow-y: auto;
  z-index: 1000;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.suggestion-item {
  padding: 0.75rem 1rem;
  cursor: pointer;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  transition: background 0.15s;
  color: #333;
}

.suggestion-item:last-child {
  border-bottom: none;
}

.suggestion-item:hover,
.suggestion-item.active {
  background: rgba(102, 126, 234, 0.1);
}

.suggestion-label {
  font-weight: 500;
  color: #333;
}

.suggestion-city {
  font-size: 0.875rem;
  color: #666;
}

.error-message {
  color: #ffcccc;
  font-size: 0.875rem;
  margin-top: 0.5rem;
}

.warning-message {
  color: #ffd700;
  font-size: 0.875rem;
  margin-top: 0.5rem;
}

.asterisk {
  color: #ef4444;
  font-weight: 700;
}
</style>

