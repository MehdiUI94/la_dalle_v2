<template>
  <div class="signup-view">
    <router-link to="/" class="home-link">
      <span class="home-icon">←</span>
      Retour à l'accueil
    </router-link>
    <div class="signup-container">
      <img src="/logo_v2.png" alt="LA DALLE" class="logo-image" />
      <div class="signup-card">
        <h2>Inscription</h2>
        
        <!-- Choix du type d'utilisateur avec tabs -->
        <div class="tabs-container">
          <div class="tabs">
            <button
              @click="selectedRole = 'client'"
              :class="['tab', { active: selectedRole === 'client' }]"
            >
              👤 Client
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

        <!-- Formulaire Client -->
        <form v-if="selectedRole === 'client'" @submit.prevent="handleSignup" class="signup-form">
          <div class="form-row">
            <div class="form-group">
              <label for="client-firstname">Prénom *</label>
              <input
                id="client-firstname"
                v-model="clientForm.firstname"
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
              type="tel"
              placeholder="06 12 34 56 78"
            />
          </div>

          <div class="form-group">
            <label for="client-ine">N° INE (Identifiant National Étudiant) *</label>
            <input
              id="client-ine"
              v-model="clientForm.ine"
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
                  type="checkbox"
                />
                <span>Par email</span>
              </label>
              <label class="checkbox-label">
                <input
                  v-model="clientForm.notifications.phone"
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
                  type="checkbox"
                />
                <span>Par email</span>
              </label>
              <label class="checkbox-label">
                <input
                  v-model="restaurantForm.notifications.phone"
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

const selectedRole = ref<Role>('client')
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

  if (selectedRole.value === 'client') {
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
      'client',
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
  padding: 2rem;
  padding-top: 4rem;
  color: white;
  position: relative;
}

.home-link {
  position: absolute;
  top: 1.5rem;
  left: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.2s;
  z-index: 10;
  font-size: 0.9rem;
}

.home-link:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateX(-2px);
}

.home-icon {
  font-size: 1.2rem;
}

@media (max-width: 640px) {
  .home-link {
    top: 1rem;
    left: 1rem;
    padding: 0.4rem 0.75rem;
    font-size: 0.85rem;
  }
  
  .home-link span:not(.home-icon) {
    display: none;
  }
  
  .home-link .home-icon {
    font-size: 1.5rem;
  }
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
  font-size: 1.75rem;
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
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

.tab.active {
  background: white;
  color: #667eea;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.required-note {
  margin-bottom: 1.5rem;
  padding: 0.75rem;
  background: rgba(255, 255, 255, 0.05);
  border-left: 3px solid rgba(255, 255, 255, 0.3);
  border-radius: 0.25rem;
  font-size: 0.85rem;
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
  padding: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  color: white;
  font-size: 1rem;
  font-family: inherit;
}

.form-group textarea {
  resize: vertical;
  min-height: 80px;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: white;
  background: rgba(255, 255, 255, 0.15);
}

.field-hint {
  display: block;
  margin-top: 0.25rem;
  font-size: 0.75rem;
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
  background: white;
  color: #667eea;
  border: none;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  margin-top: 0.5rem;
}

.submit-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
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
  color: white;
  font-weight: 600;
  text-decoration: underline;
}

@media (max-width: 640px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>

