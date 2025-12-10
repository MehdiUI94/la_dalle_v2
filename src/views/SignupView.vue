<template>
  <div class="signup-view">
    <div class="signup-container">
      <img src="/logo_v2.png" alt="LA DALLE" class="logo-image" />
      <div class="signup-card">
        <h2 class="section-title">INSCRIPTION</h2>
        
        <!-- Choix du type d'utilisateur avec tabs -->
        <div class="tabs-container">
          <div class="tabs">
            <button
              @click="selectedRole = 'etudiant'"
              :class="['tab', { active: selectedRole === 'etudiant' }]"
            >
              👤 Étudiant
            </button>
            <button
              @click="selectedRole = 'restaurant'"
              :class="['tab', { active: selectedRole === 'restaurant' }]"
            >
              🍽️ Restaurant
            </button>
          </div>
        </div>

        <!-- Mention sur les champs obligatoires -->
        <p class="required-note">
          <span class="asterisk">*</span> Les champs marqués d'une astérisque sont obligatoires
        </p>

        <!-- Formulaire Étudiant -->
        <form v-if="selectedRole === 'etudiant'" @submit.prevent="handleSignup" class="signup-form">
          <div class="form-row">
            <div class="form-group">
              <label for="client-firstname">Prénom *</label>
              <input
                id="client-firstname"
                v-model="clientForm.firstname"
                class="form-field"
              type="text"
                placeholder="Jean"
                required
              />
            </div>
            <div class="form-group">
              <label for="client-lastname">Nom *</label>
              <input
                id="client-lastname"
                v-model="clientForm.lastname"
                class="form-field"
              type="text"
                placeholder="Dupont"
                required
              />
            </div>
          </div>

          <div class="form-group">
            <label for="client-age">Âge *</label>
            <input
              id="client-age"
              v-model.number="clientForm.age"
              class="form-field"
              type="number"
              min="13"
              max="120"
              placeholder="25"
              required
            />
          </div>

          <AddressAutocomplete
            ref="clientAddressRef"
            v-model="clientForm.address"
            label="Adresse"
            input-id="client-address"
            placeholder="Commencez à taper une adresse..."
            :required="true"
            @validation-change="clientAddressValid = $event"
          />

          <div class="form-group">
            <label for="client-email">Email *</label>
            <input
              id="client-email"
              v-model="clientForm.email"
              class="form-field"
              type="email"
              placeholder="votre@email.com"
              required
            />
          </div>

          <div class="form-group">
            <label for="client-password">Mot de passe *</label>
            <input
              id="client-password"
              v-model="clientForm.password"
              class="form-field"
              type="password"
              placeholder="••••••••"
              required
              minlength="6"
            />
          </div>

          <div class="form-group">
            <label for="client-phone">
              Numéro de téléphone
              <span class="optional-label">(optionnel)</span>
            </label>
            <input
              id="client-phone"
              v-model="clientForm.phone"
              class="form-field"
              type="tel"
              placeholder="06 12 34 56 78"
            />
          </div>

          <div class="form-group">
            <label for="client-ine">N° INE (Identifiant National Étudiant) *</label>
            <input
              id="client-ine"
              v-model="clientForm.ine"
              class="form-field"
              type="text"
              placeholder="1234567890A"
              required
              pattern="[0-9]{10}[A-Z]|[0-9]{11}"
              title="Le N° INE doit contenir 10 chiffres suivis d'une lettre ou 11 chiffres"
            />
            <small class="field-hint">Format : 10 chiffres + 1 lettre (ex: 1234567890A) ou 11 chiffres</small>
          </div>

          <div class="form-group">
            <label>Notifications *</label>
            <div class="checkbox-group">
              <label class="checkbox-label">
                <input
                  v-model="clientForm.notifications.email"
                  class="form-field"
              type="checkbox"
                />
                <span>Par email</span>
              </label>
              <label class="checkbox-label">
                <input
                  v-model="clientForm.notifications.phone"
                  class="form-field"
              type="checkbox"
                />
                <span>Par téléphone</span>
              </label>
            </div>
          </div>

          <div v-if="validationError || apiErrorMessage" class="error-message">
            {{ validationError || apiErrorMessage }}
          </div>

          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Inscription...</span>
            <span v-else>S'inscrire</span>
          </button>
        </form>

        <!-- Formulaire Restaurant -->
        <form v-if="selectedRole === 'restaurant'" @submit.prevent="handleSignup" class="signup-form">
          <div class="form-row">
            <div class="form-group">
              <label for="resto-firstname">Prénom du restaurateur *</label>
              <input
                id="resto-firstname"
                v-model="restaurantForm.ownerFirstname"
                class="form-field"
              type="text"
                placeholder="Jean"
                required
              />
            </div>
            <div class="form-group">
              <label for="resto-lastname">Nom du restaurateur *</label>
              <input
                id="resto-lastname"
                v-model="restaurantForm.ownerLastname"
                class="form-field"
              type="text"
                placeholder="Dupont"
                required
              />
            </div>
          </div>

          <div class="form-group">
            <label for="resto-name">Nom du restaurant *</label>
            <input
              id="resto-name"
              v-model="restaurantForm.name"
              class="form-field"
              type="text"
              placeholder="Le Bon Restaurant"
              required
            />
          </div>

          <AddressAutocomplete
            ref="restaurantAddressRef"
            v-model="restaurantForm.address"
            label="Adresse du restaurant"
            input-id="resto-address"
            placeholder="Commencez à taper une adresse..."
            :required="true"
            @validation-change="restaurantAddressValid = $event"
          />

          <div class="form-group">
            <label for="resto-description">
              Description du restaurant
              <span class="optional-label">(optionnel)</span>
            </label>
            <textarea
              class="form-textarea"
              id="resto-description"
              v-model="restaurantForm.description"
              rows="3"
              placeholder="Une brève description de votre restaurant..."
            ></textarea>
          </div>

          <ImageInput
            v-model="restaurantForm.logo"
            label="Logo du restaurant"
            input-id="resto-logo"
            url-placeholder="https://exemple.com/logo.png"
            :optional="true"
            folder="restaurant-logos"
          />

          <div class="form-row">
            <div class="form-group">
              <label for="resto-siren">Numéro SIREN *</label>
              <input
                id="resto-siren"
                v-model="restaurantForm.siren"
                class="form-field"
              type="text"
                placeholder="123456789"
                required
              />
            </div>
            <div class="form-group">
              <label for="resto-siret">Numéro SIRET *</label>
              <input
                id="resto-siret"
                v-model="restaurantForm.siret"
                class="form-field"
              type="text"
                placeholder="12345678901234"
                required
              />
            </div>
          </div>

          <div class="form-group">
            <label for="resto-email">Email *</label>
            <input
              id="resto-email"
              v-model="restaurantForm.email"
              class="form-field"
              type="email"
              placeholder="contact@restaurant.com"
              required
            />
          </div>

          <div class="form-group">
            <label for="resto-password">Mot de passe *</label>
            <input
              id="resto-password"
              v-model="restaurantForm.password"
              class="form-field"
              type="password"
              placeholder="••••••••"
              required
              minlength="6"
            />
          </div>

          <div class="form-group">
            <label for="resto-social">
              Réseaux sociaux (URLs séparées par des virgules)
              <span class="optional-label">(optionnel)</span>
            </label>
            <input
              id="resto-social"
              v-model="restaurantForm.socialMedia"
              class="form-field"
              type="text"
              placeholder="https://instagram.com/restaurant, https://facebook.com/restaurant"
            />
          </div>

          <div class="form-group">
            <label for="resto-phone">
              Numéro de téléphone
              <span class="optional-label">(optionnel)</span>
            </label>
            <input
              id="resto-phone"
              v-model="restaurantForm.phone"
              class="form-field"
              type="tel"
              placeholder="01 23 45 67 89"
            />
          </div>

          <div class="form-group">
            <label>Notifications *</label>
            <div class="checkbox-group">
              <label class="checkbox-label">
                <input
                  v-model="restaurantForm.notifications.email"
                  class="form-field"
              type="checkbox"
                />
                <span>Par email</span>
              </label>
              <label class="checkbox-label">
                <input
                  v-model="restaurantForm.notifications.phone"
                  class="form-field"
              type="checkbox"
                />
                <span>Par téléphone</span>
              </label>
            </div>
          </div>

          <div v-if="validationError || apiErrorMessage" class="error-message">
            {{ validationError || apiErrorMessage }}
          </div>

          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Inscription...</span>
            <span v-else>S'inscrire</span>
          </button>
        </form>

        <p class="login-link">
          Déjà un compte ? 
          <router-link to="/login">Connectez-vous</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import type { Role } from '@/types/profile'
import ImageInput from '@/components/shared/ImageInput.vue'
import AddressAutocomplete from '@/components/shared/AddressAutocomplete.vue'

const router = useRouter()
const { signup, isLoading, errorMessage: apiErrorMessage } = useAuth()

const selectedRole = ref<Role>('etudiant')
const validationError = ref<string | null>(null)
const clientAddressRef = ref<InstanceType<typeof AddressAutocomplete> | null>(null)
const restaurantAddressRef = ref<InstanceType<typeof AddressAutocomplete> | null>(null)
const clientAddressValid = ref(false)
const restaurantAddressValid = ref(false)

const clientForm = reactive({
  firstname: '',
  lastname: '',
  age: null as number | null,
  address: '',
  email: '',
  password: '',
  phone: '',
  ine: '',
  notifications: {
    email: false,
    phone: false
  }
})

const restaurantForm = reactive({
  ownerFirstname: '',
  ownerLastname: '',
  name: '',
  address: '',
  description: '',
  logo: '',
  siren: '',
  siret: '',
  email: '',
  password: '',
  socialMedia: '',
  phone: '',
  notifications: {
    email: false,
    phone: false
  }
})

const handleSignup = async () => {
  // Réinitialiser les messages d'erreur
  validationError.value = null

  if (selectedRole.value === 'etudiant') {
    // Vérifier que l'adresse est valide (sélectionnée dans la liste)
    if (!clientAddressValid.value || !clientForm.address) {
      validationError.value = 'Veuillez sélectionner une adresse dans la liste proposée'
      return
    }
    
    // Vérifier qu'au moins une notification est sélectionnée
    if (!clientForm.notifications.email && !clientForm.notifications.phone) {
      validationError.value = 'Veuillez sélectionner au moins un moyen de notification (email ou téléphone)'
      return
    }
    
    // Valider le format du N° INE
    const inePattern = /^[0-9]{10}[A-Z]|[0-9]{11}$/
    if (!inePattern.test(clientForm.ine)) {
      validationError.value = 'Le N° INE doit contenir 10 chiffres suivis d\'une lettre (ex: 1234567890A) ou 11 chiffres'
      return
    }

    const success = await signup(
      clientForm.email,
      clientForm.password,
      'etudiant',
      {
        firstname: clientForm.firstname,
        lastname: clientForm.lastname,
        age: clientForm.age!,
        address: clientForm.address,
        phone: clientForm.phone || null,
        ine: clientForm.ine,
        notifications: clientForm.notifications
      }
    )
    
    if (success) {
      router.push('/login')
    }
  } else {
    // Vérifier que l'adresse est valide (sélectionnée dans la liste)
    if (!restaurantAddressValid.value || !restaurantForm.address) {
      validationError.value = 'Veuillez sélectionner une adresse dans la liste proposée'
      return
    }
    
    // Vérifier qu'au moins une notification est sélectionnée
    if (!restaurantForm.notifications.email && !restaurantForm.notifications.phone) {
      validationError.value = 'Veuillez sélectionner au moins un moyen de notification (email ou téléphone)'
      return
    }
    
    const success = await signup(
      restaurantForm.email,
      restaurantForm.password,
      'restaurant',
      {
        ownerFirstname: restaurantForm.ownerFirstname,
        ownerLastname: restaurantForm.ownerLastname,
        name: restaurantForm.name,
        address: restaurantForm.address,
        description: restaurantForm.description || null,
        logo: restaurantForm.logo || null,
        siren: restaurantForm.siren,
        siret: restaurantForm.siret,
        socialMedia: restaurantForm.socialMedia || null,
        phone: restaurantForm.phone || null,
        notifications: restaurantForm.notifications
      }
    )
    
    if (success) {
      router.push('/login')
    }
  }
}
</script>

<style scoped>
.signup-view {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 80px;
  padding-top: 4rem;
  color: var(--foreground);
  position: relative;
}

.signup-container {
  width: 100%;
  max-width: 600px;
}

.logo-image {
  height: 80px;
  width: auto;
  object-fit: contain;
  margin-bottom: 2rem;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.signup-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  width: 100%;
}

.signup-card h2 {
  margin-bottom: 1.5rem;
  text-align: center;
}

.tabs-container {
  margin-bottom: 1.5rem;
}

.tabs {
  display: flex;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  padding: 0.25rem;
  gap: 0.25rem;
}

.tab {
  flex: 1;
  padding: 0.75rem 1rem;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.7);
  border-radius: 0.375rem;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.tab:hover {
  color: var(--foreground);
  background: rgba(255, 255, 255, 0.1);
}

.tab:active {
  opacity: 0.7;
  transform: scale(0.98);
}

.tab.active {
  background: white;
  color: var(--primary);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.required-note {
  margin-bottom: 1.5rem;
  padding: 0.75rem;
  background: rgba(255, 255, 255, 0.05);
  border-left: 3px solid rgba(255, 255, 255, 0.3);
  border-radius: 0.25rem;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.9);
}

.asterisk {
  color: #ef4444;
  font-weight: 700;
  margin-right: 0.25rem;
}

.signup-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
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

.form-group input,
.form-group textarea {
  /* Utilise les classes form-field et form-textarea définies dans style.css */
}

.form-group textarea {
  min-height: 100px;
}

.field-hint {
  display: block;
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
}

.optional-label {
  font-style: italic;
  font-weight: normal;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9em;
  margin-left: 0.25rem;
}

.checkbox-group {
  display: flex;
  flex-direction: row;
  gap: 1.5rem;
  flex-wrap: wrap;
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
  text-align: center;
}

.submit-button {
  padding: 0.875rem;
  background: var(--primary);
  color: var(--background);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
  margin-top: 0.5rem;
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

.login-link {
  margin-top: 1.5rem;
  text-align: center;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.8);
}

.login-link a {
  color: var(--foreground);
  font-weight: 600;
  text-decoration: underline;
}

@media (max-width: 768px) {
  .signup-view {
    padding: 2rem 1rem;
  }
}

@media (max-width: 640px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>

