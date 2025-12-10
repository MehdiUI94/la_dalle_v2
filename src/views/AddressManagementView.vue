<template>
  <div class="address-management-view">
    <BackButton />
    <div v-if="isLoading && addresses.length === 0" class="loading-message">
      <div class="spinner"></div>
      <p>Chargement des adresses...</p>
    </div>

    <div v-else class="addresses-container">
      <!-- Liste des adresses existantes -->
      <div v-if="addresses.length > 0" class="addresses-list">
        <h3 class="section-title">Mes adresses</h3>
        <div class="address-cards">
          <div
            v-for="address in addresses"
            :key="address.id"
            class="address-card"
            :class="{ 'is-default': address.is_default, 'is-selected': selectedAddressId === address.id }"
          >
            <div class="address-header">
              <div class="address-info">
                <h4 class="address-label">
                  {{ address.label || 'Adresse' }}
                  <span v-if="address.is_default" class="default-badge">Par défaut</span>
                </h4>
                <p class="address-text">{{ address.address }}</p>
                <p v-if="address.lat && address.lng" class="address-coords">
                  📍 {{ address.lat.toFixed(6) }}, {{ address.lng.toFixed(6) }}
                </p>
              </div>
              <div class="address-actions">
                <button
                  v-if="!address.is_default"
                  @click="setAsDefault(address.id)"
                  class="action-button default-button"
                  title="Définir comme adresse par défaut"
                >
                  ⭐
                </button>
                <button
                  @click="selectAddress(address.id)"
                  class="action-button select-button"
                  :class="{ active: selectedAddressId === address.id }"
                  title="Utiliser cette adresse"
                >
                  {{ selectedAddressId === address.id ? '✓' : '→' }}
                </button>
                <button
                  v-if="!address.is_default"
                  @click="deleteAddress(address.id)"
                  class="action-button delete-button"
                  title="Supprimer"
                >
                  🗑️
                </button>
              </div>
            </div>
            <div v-if="address.lat && address.lng" class="address-map-preview">
              <MapPreview :lat="address.lat" :lng="address.lng" :address="address.address" />
            </div>
          </div>
        </div>
      </div>

      <!-- Bouton pour afficher le formulaire d'ajout -->
      <div v-if="!showAddForm" class="add-address-button-container">
        <button @click="showAddForm = true" class="add-address-button">
          <span class="button-icon">➕</span>
          <span>{{ addresses.length > 0 ? 'Ajouter une nouvelle adresse' : 'Ajouter votre première adresse' }}</span>
        </button>
      </div>

      <!-- Formulaire pour ajouter une nouvelle adresse -->
      <div v-if="showAddForm" class="add-address-section">
        <div class="form-header">
          <h3 class="section-title">{{ addresses.length > 0 ? 'AJOUTER UNE NOUVELLE ADRESSE' : 'AJOUTER VOTRE PREMIÈRE ADRESSE' }}</h3>
          <button @click="closeAddForm" class="close-button" title="Fermer">
            ✕
          </button>
        </div>
        
        <form @submit.prevent="handleAddAddress" class="add-address-form">
          <div class="form-group">
            <label for="address-label">Label (optionnel)</label>
            <input
              id="address-label"
              v-model="newAddress.label"
              type="text"
              class="form-field"
              placeholder="Ex: Domicile, Travail, Université..."
              maxlength="50"
            />
          </div>

          <div class="form-group">
            <AddressAutocomplete
              v-model="newAddress.address"
              label="Adresse"
              input-id="new-address"
              placeholder="Commencez à taper une adresse..."
              :required="true"
              @validation-change="isAddressValid = $event"
            />
          </div>

          <div v-if="previewCoords" class="address-preview">
            <h4>Aperçu</h4>
            <MapPreview :lat="previewCoords.lat" :lng="previewCoords.lng" :address="newAddress.address" />
          </div>

          <div class="form-options">
            <label class="checkbox-label">
              <input
                v-model="newAddress.isDefault"
                type="checkbox"
              />
              <span>Définir comme adresse par défaut</span>
            </label>
          </div>

          <div v-if="error" class="error-message">
            {{ error }}
          </div>

          <button
            type="submit"
            :disabled="!isAddressValid || isLoading || !newAddress.address"
            class="submit-button"
          >
            <span v-if="isLoading">Ajout en cours...</span>
            <span v-else>Ajouter l'adresse</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { useLocationStore } from '@/stores/location'
import AddressAutocomplete from '@/components/shared/AddressAutocomplete.vue'
import MapPreview from '@/components/map/MapPreview.vue'
import BackButton from '@/components/shared/BackButton.vue'

const userStore = useUserStore()
const locationStore = useLocationStore()

const addresses = computed(() => locationStore.addresses)
const selectedAddressId = computed(() => locationStore.selectedAddressId)
const isLoading = computed(() => locationStore.isLoading)
const error = ref<string | null>(null)

const newAddress = ref({
  address: '',
  label: '',
  isDefault: false
})

const isAddressValid = ref(false)
const previewCoords = ref<{ lat: number; lng: number } | null>(null)
const showAddForm = ref(false)

// Charger les adresses au montage
onMounted(async () => {
  if (userStore.user?.role === 'etudiant' && userStore.user?.id) {
    await locationStore.loadAddresses(userStore.user.id)
  }
})

// Géocoder l'adresse pour l'aperçu
watch(() => newAddress.value.address, async (newAddressValue) => {
  if (newAddressValue && isAddressValid.value) {
    const coords = await locationStore.geocodeAddress(newAddressValue)
    previewCoords.value = coords
  } else {
    previewCoords.value = null
  }
})

const closeAddForm = () => {
  showAddForm.value = false
  // Réinitialiser le formulaire
  newAddress.value = {
    address: '',
    label: '',
    isDefault: false
  }
  isAddressValid.value = false
  previewCoords.value = null
  error.value = null
}

const handleAddAddress = async () => {
  if (!userStore.user?.id || !isAddressValid.value) return

  error.value = null

  try {
    await locationStore.addAddress(
      userStore.user.id,
      newAddress.value.address,
      newAddress.value.label || null,
      newAddress.value.isDefault
    )

    // Fermer et réinitialiser le formulaire
    closeAddForm()
  } catch (err: any) {
    error.value = err.message || 'Erreur lors de l\'ajout de l\'adresse'
  }
}

const setAsDefault = async (addressId: string) => {
  if (!userStore.user?.id) return

  error.value = null
  try {
    await locationStore.setDefaultAddress(userStore.user.id, addressId)
  } catch (err: any) {
    error.value = err.message || 'Erreur lors de la définition de l\'adresse par défaut'
  }
}

const selectAddress = (addressId: string) => {
  locationStore.selectAddress(addressId)
}

const deleteAddress = async (addressId: string) => {
  if (!userStore.user?.id) return
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette adresse ?')) return

  error.value = null
  try {
    await locationStore.deleteAddress(addressId, userStore.user.id)
  } catch (err: any) {
    error.value = err.message || 'Erreur lors de la suppression de l\'adresse'
  }
}
</script>

<style scoped>
.address-management-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: var(--foreground);
  max-width: 1200px;
  margin: 0 auto;
}

.address-management-view :deep(.back-button) {
  margin-bottom: 1.5rem;
}

.page-title {
  font-size: 2rem;
  margin-bottom: 2rem;
}

.loading-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  gap: 1rem;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.addresses-container {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.section-title {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
}

.address-cards {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.address-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 1.5rem;
  border: 2px solid rgba(255, 255, 255, 0.2);
  transition: all 0.2s;
}

.address-card.is-default {
  border-color: #ffc107;
  background: rgba(255, 193, 7, 0.1);
}

.address-card.is-selected {
  border-color: var(--primary);
  background: rgba(255, 107, 0, 0.1);
}

.address-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 1rem;
}

.address-info {
  flex: 1;
}

.address-label {
  font-size: 1.1rem;
  font-weight: 600;
  margin: 0 0 0.5rem 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.default-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  background: rgba(255, 193, 7, 0.3);
  color: #ffc107;
  border-radius: 50px;
  font-size: 0.875rem;
  font-weight: 600;
}

.address-text {
  margin: 0.5rem 0;
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.9);
}

.address-coords {
  margin: 0.5rem 0 0 0;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.6);
}

.address-actions {
  display: flex;
  gap: 0.5rem;
}

.action-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: var(--foreground);
  border-radius: 0.5rem;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 1.2rem;
  transition: all 0.2s;
}

.action-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.action-button:active {
  transform: translateY(0);
  opacity: 0.7;
}

.action-button.select-button.active {
  background: var(--primary);
  border-color: var(--primary);
}

.action-button.default-button:hover {
  background: rgba(255, 193, 7, 0.3);
}

.action-button.delete-button:hover {
  background: rgba(239, 68, 68, 0.3);
}

.address-map-preview {
  margin-top: 1rem;
}

.add-address-button-container {
  display: flex;
  justify-content: center;
  margin-top: 1rem;
}

.add-address-button {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 0.75rem;
  color: var(--foreground);
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.add-address-button:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.add-address-button:active {
  transform: translateY(0);
  opacity: 0.8;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.button-icon {
  font-size: 1.25rem;
}

.add-address-section {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.form-header .section-title {
  margin-bottom: 0;
}

.close-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: var(--foreground);
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 1.2rem;
  transition: all 0.2s;
}

.close-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: rotate(90deg);
}

.close-button:active {
  opacity: 0.7;
  transform: rotate(90deg) scale(0.95);
}

.add-address-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
  font-size: 0.9rem;
}

.form-group input {
  /* Utilise les classes form-field définies dans style.css */
}

.address-preview {
  margin-top: 1rem;
}

.address-preview h4 {
  margin-bottom: 1rem;
  font-size: 1rem;
  font-weight: 600;
}

.form-options {
  display: flex;
  align-items: center;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.error-message {
  padding: 0.75rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  border-radius: 0.5rem;
  color: #ffcccc;
  font-size: 0.9rem;
}

.submit-button {
  padding: 0.875rem 1.5rem;
  background: var(--primary);
  color: var(--background);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
}

.submit-button:hover:not(:disabled) {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.submit-button:active:not(:disabled) {
  transform: translate(0, 0);
  opacity: 0.8;
  box-shadow: 4px 4px 0 0 var(--black);
}

.submit-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .address-management-view {
    padding: 2rem 1rem;
  }

  .address-header {
    flex-direction: column;
  }

  .address-actions {
    width: 100%;
    justify-content: flex-start;
  }
}
</style>

