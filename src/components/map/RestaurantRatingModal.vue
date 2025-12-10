<template>
  <Transition name="modal">
    <div v-if="isOpen" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Noter {{ restaurantName }}</h2>
          <button @click="closeModal" class="close-button" aria-label="Fermer">×</button>
        </div>

        <div class="modal-body">
          <div v-if="isLoading" class="loading-message">
            <div class="spinner"></div>
            <p>Chargement...</p>
          </div>

          <div v-else-if="!hasVisited" class="no-visit-message">
            <div class="no-visit-icon">📱</div>
            <h3>Visite requise</h3>
            <p>Vous devez avoir visité ce restaurant au moins une fois avant de pouvoir le noter.</p>
            <p class="scan-instruction">Scannez le QR code du restaurant lors de votre visite pour débloquer la notation.</p>
            <router-link to="/scan" class="scan-link-button" @click="closeModal">
              Scanner un QR code
            </router-link>
          </div>

          <div v-else>
            <!-- Note moyenne actuelle -->
            <div v-if="averageRating !== null" class="current-rating">
              <p class="rating-label">Note moyenne :</p>
              <div class="rating-display">
                <span class="rating-value">{{ averageRating.toFixed(1) }}</span>
                <div class="stars">
                  <span
                    v-for="star in 5"
                    :key="star"
                    class="star"
                    :class="{ filled: star <= Math.round(averageRating) }"
                  >
                    ⭐
                  </span>
                </div>
                <span class="rating-count" v-if="ratingCount > 0">({{ ratingCount }} avis)</span>
              </div>
            </div>

            <!-- Votre note actuelle -->
            <div v-if="userRating !== null" class="user-rating-section">
              <p class="rating-label">Votre note actuelle :</p>
              <div class="stars-display">
                <span
                  v-for="star in 5"
                  :key="star"
                  class="star"
                  :class="{ filled: star <= userRating }"
                >
                  ⭐
                </span>
                <span class="rating-text">{{ userRating }}/5</span>
              </div>
            </div>

            <!-- Sélection de la note -->
            <div class="rating-input-section">
              <label class="rating-label">Votre note :</label>
              <div class="stars-input">
                <button
                  v-for="star in 5"
                  :key="star"
                  type="button"
                  class="star-button"
                  :class="{ active: star <= selectedRating }"
                  @click="selectedRating = star"
                  @mouseenter="hoveredStar = star"
                  @mouseleave="hoveredStar = 0"
                  :aria-label="`Noter ${star} sur 5`"
                >
                  ⭐
                </button>
              </div>
              <button
                v-if="selectedRating > 0"
                @click="selectedRating = 0"
                class="clear-rating-button"
              >
                Effacer
              </button>
            </div>

            <!-- Commentaire optionnel -->
            <div class="comment-section">
              <label for="rating-comment" class="comment-label">Commentaire (optionnel)</label>
              <textarea
                id="rating-comment"
                v-model="comment"
                rows="3"
                placeholder="Partagez votre expérience..."
                maxlength="500"
                class="comment-textarea"
              ></textarea>
              <span class="char-count">{{ comment.length }}/500</span>
            </div>

            <!-- Message d'erreur -->
            <div v-if="error" class="error-message">
              {{ error }}
            </div>

            <!-- Message de succès -->
            <div v-if="successMessage" class="success-message">
              {{ successMessage }}
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button @click="closeModal" class="cancel-button">Annuler</button>
          <button
            @click="submitRating"
            :disabled="selectedRating === 0 || isSubmitting"
            class="submit-button"
          >
            <span v-if="isSubmitting">Enregistrement...</span>
            <span v-else>{{ userRating !== null ? 'Modifier la note' : 'Enregistrer la note' }}</span>
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { ref, watch, computed, onMounted } from 'vue'
import { useRestaurantRatings } from '@/composables/useRestaurantRatings'
import { useUserStore } from '@/stores/user'
import { useQRScan } from '@/composables/useQRScan'
import { supabase } from '@/lib/supabaseClient'

interface Props {
  restaurantId: string | null
  restaurantName: string
  isOpen: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:isOpen': [value: boolean]
  'rating-updated': []
}>()

const userStore = useUserStore()
const { rateRestaurant, getRestaurantAverageRating, getClientRating } = useRestaurantRatings()
const { hasVisitedRestaurant } = useQRScan()

const selectedRating = ref(0)
const comment = ref('')
const hoveredStar = ref(0)
const userRating = ref<number | null>(null)
const averageRating = ref<number | null>(null)
const ratingCount = ref(0)
const error = ref<string | null>(null)
const successMessage = ref<string | null>(null)
const isSubmitting = ref(false)
const isLoading = ref(false)

const isOpen = computed({
  get: () => props.isOpen,
  set: (value) => emit('update:isOpen', value)
})

const closeModal = () => {
  isOpen.value = false
  // Réinitialiser le formulaire après fermeture
  setTimeout(() => {
    selectedRating.value = 0
    comment.value = ''
    error.value = null
    successMessage.value = null
  }, 300)
}

// Charger les données du restaurant quand la modal s'ouvre
watch(() => props.isOpen, async (open) => {
  if (open && props.restaurantId && userStore.user?.id) {
    await checkVisitStatus()
    await loadRestaurantData()
  }
})

const checkVisitStatus = async () => {
  if (!props.restaurantId || !userStore.user?.id) return
  
  hasVisited.value = await hasVisitedRestaurant(userStore.user.id, props.restaurantId)
  canRate.value = hasVisited.value
}

const loadRestaurantData = async () => {
  if (!props.restaurantId || !userStore.user?.id) return

  isLoading.value = true
  error.value = null

  try {
    // Charger la note moyenne
    const avgRating = await getRestaurantAverageRating(props.restaurantId)
    averageRating.value = avgRating

    // Charger le nombre total de notes
    const { count } = await supabase
      .from('restaurant_ratings')
      .select('*', { count: 'exact', head: true })
      .eq('restaurant_id', props.restaurantId)
    
    ratingCount.value = count || 0

    // Charger la note de l'utilisateur
    const clientRating = await getClientRating(userStore.user.id, props.restaurantId)
    if (clientRating) {
      userRating.value = clientRating.rating
      selectedRating.value = clientRating.rating
      comment.value = clientRating.comment || ''
    } else {
      userRating.value = null
      selectedRating.value = 0
      comment.value = ''
    }
  } catch (err: any) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = 'Erreur lors du chargement des données'
  } finally {
    isLoading.value = false
  }
}

const submitRating = async () => {
  if (!props.restaurantId || !userStore.user?.id || selectedRating.value === 0) return

  isSubmitting.value = true
  error.value = null
  successMessage.value = null

  try {
    const result = await rateRestaurant(
      userStore.user.id,
      props.restaurantId,
      selectedRating.value,
      comment.value || null
    )

    if (result) {
      successMessage.value = userRating.value !== null ? 'Note modifiée avec succès !' : 'Note enregistrée avec succès !'
      
      // Recharger les données
      await loadRestaurantData()
      
      // Émettre l'événement pour mettre à jour la carte
      emit('rating-updated')
      
      // Fermer la modal après 1.5 secondes
      setTimeout(() => {
        closeModal()
      }, 1500)
    }
  } catch (err: any) {
    console.error('Erreur lors de l\'enregistrement de la note:', err)
    error.value = err.message || 'Erreur lors de l\'enregistrement de la note'
  } finally {
    isSubmitting.value = false
  }
}

onMounted(() => {
  if (props.isOpen && props.restaurantId) {
    loadRestaurantData()
  }
})
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: linear-gradient(135deg, var(--primary) 0%, var(--yellow) 100%);
  border-radius: 1rem;
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.modal-header h2 {
  margin: 0;
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
}

.close-button {
  background: none;
  border: none;
  color: white;
  font-size: 2rem;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background 0.2s;
}

.close-button:hover {
  background: rgba(255, 255, 255, 0.2);
}

.modal-body {
  padding: 1.5rem;
  flex: 1;
  overflow-y: auto;
}

.loading-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
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

.current-rating {
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.rating-label {
  margin: 0 0 0.5rem 0;
  font-weight: 500;
  color: white;
  font-size: 0.9rem;
}

.rating-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.rating-value {
  font-weight: 600;
  font-size: 1.25rem;
  color: #fbbf24;
}

.stars {
  display: flex;
  gap: 0.1rem;
}

.star {
  font-size: 1.25rem;
  opacity: 0.3;
  transition: opacity 0.2s;
}

.star.filled {
  opacity: 1;
}

.rating-count {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
}

.user-rating-section {
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.stars-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.rating-text {
  font-weight: 600;
  color: white;
}

.rating-input-section {
  margin-bottom: 1.5rem;
}

.stars-input {
  display: flex;
  gap: 0.5rem;
  margin: 0.5rem 0;
}

.star-button {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  padding: 0;
  transition: transform 0.2s, filter 0.2s;
  opacity: 0.3;
}

.star-button:hover {
  transform: scale(1.2);
  opacity: 0.7;
}

.star-button.active {
  opacity: 1;
  filter: brightness(1.2);
}

.clear-rating-button {
  padding: 0.25rem 0.75rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.4);
  border-radius: 0.25rem;
  color: #ffcccc;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 0.5rem;
}

.clear-rating-button:hover {
  background: rgba(239, 68, 68, 0.3);
}

.comment-section {
  margin-bottom: 1rem;
}

.comment-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: white;
  font-size: 0.9rem;
}

.comment-textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  color: white;
  font-size: 0.9rem;
  font-family: inherit;
  resize: vertical;
  min-height: 80px;
}

.comment-textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.comment-textarea:focus {
  outline: none;
  border-color: white;
  background: rgba(255, 255, 255, 0.15);
}

.char-count {
  display: block;
  text-align: right;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 0.25rem;
}

.error-message {
  padding: 0.75rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  border-radius: 0.5rem;
  color: #ffcccc;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.success-message {
  padding: 0.75rem;
  background: rgba(34, 197, 94, 0.2);
  border: 1px solid rgba(34, 197, 94, 0.5);
  border-radius: 0.5rem;
  color: #bbf7d0;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.cancel-button {
  padding: 0.75rem 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 0.5rem;
  color: white;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.cancel-button:hover {
  background: rgba(255, 255, 255, 0.2);
}

.submit-button {
  padding: 0.75rem 1.5rem;
  background: white;
  border: none;
  border-radius: 0.5rem;
  color: var(--primary);
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.submit-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.submit-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.no-visit-message {
  text-align: center;
  padding: 2rem;
}

.no-visit-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.no-visit-message h3 {
  margin: 0 0 1rem 0;
  color: white;
  font-size: 1.5rem;
}

.no-visit-message p {
  margin: 0.5rem 0;
  color: rgba(255, 255, 255, 0.9);
  font-size: 1rem;
}

.scan-instruction {
  margin-top: 1rem !important;
  font-style: italic;
  color: rgba(255, 255, 255, 0.7) !important;
}

.scan-link-button {
  display: inline-block;
  margin-top: 1.5rem;
  padding: 0.75rem 1.5rem;
  background: white;
  color: var(--primary);
  border: none;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s;
}

.scan-link-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-content,
.modal-leave-active .modal-content {
  transition: transform 0.3s;
}

.modal-enter-from .modal-content,
.modal-leave-to .modal-content {
  transform: scale(0.9);
}
</style>

