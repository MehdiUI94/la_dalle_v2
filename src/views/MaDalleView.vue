<template>
  <div class="ma-dalle-view">
    <h2 class="page-title section-title">MA DALLE</h2>
    
    <!-- Scanner QR Code -->
    <section class="scanner-section">
      <h3 class="section-title">SCANNER UN QR CODE</h3>
      <div v-if="error" class="error-message">
        {{ error }}
      </div>

      <div v-if="successMessage" class="success-message">
        {{ successMessage }}
      </div>

      <div v-if="isScanning" class="scanner-wrapper">
        <video ref="videoElement" class="scanner-video" autoplay playsinline></video>
        <div class="scanner-overlay">
          <div class="scanner-frame"></div>
        </div>
        <button @click="stopScanning" class="stop-button">Arrêter le scan</button>
      </div>

      <div v-else class="scan-actions">
        <button @click="startScanning" class="start-button" :disabled="isLoading">
          <span v-if="isLoading">Chargement...</span>
          <span v-else>📷 Scanner le QR code</span>
        </button>
      </div>
    </section>

    <!-- Liste des restaurants visités -->
    <section v-if="visits.length > 0" class="visits-section">
      <h3 class="section-title">MES RESTAURANTS VISITÉS</h3>
      
      <div v-if="visitsLoading" class="loading-message">
        <div class="spinner"></div>
        <p>Chargement...</p>
      </div>

      <div v-else class="visits-list">
        <div
          v-for="visit in visits"
          :key="visit.id"
          class="visit-card"
        >
          <div class="visit-header">
            <h4 class="restaurant-name">{{ visit.restaurant_name }}</h4>
            <span v-if="visit.restaurant_address" class="restaurant-address">
              📍 {{ visit.restaurant_address }}
            </span>
          </div>

          <!-- Note existante ou possibilité de noter -->
          <div class="rating-section">
            <div v-if="visit.has_rating" class="existing-rating">
              <span class="rating-label">Votre note :</span>
              <div class="stars-display">
                <span
                  v-for="i in 5"
                  :key="i"
                  class="star"
                  :class="{ filled: i <= (visit.rating || 0) }"
                >
                  ⭐
                </span>
              </div>
              <span class="rating-value">{{ visit.rating }}/5</span>
            </div>
            <div v-else-if="visit.can_rate" class="rate-action">
              <button @click="openRatingModal(visit)" class="rate-button">
                Noter ce restaurant
              </button>
            </div>
            <div v-else class="no-rating">
              <span class="no-rating-text">Visitez le restaurant pour pouvoir le noter</span>
            </div>
          </div>

          <!-- Jauge de progression pour la récompense -->
          <div class="reward-progress">
            <div class="progress-header">
              <span class="progress-label">Progression vers la récompense gratuite</span>
              <span class="progress-count">
                {{ visit.order_count }} / 10 commandes
              </span>
            </div>
            <div class="progress-bar-container">
            <div
              class="progress-bar"
              :style="{ width: `${Math.min(100, ((visit.order_count % 10) / 10) * 100)}%` }"
            ></div>
            </div>
            <p class="remaining-text">
              <span v-if="visit.remaining_for_reward > 0">
                Il reste {{ visit.remaining_for_reward }} commande{{ visit.remaining_for_reward > 1 ? 's' : '' }} avant votre récompense gratuite ! 🎁
              </span>
              <span v-else class="reward-ready">
                🎉 Vous avez atteint 10 commandes ! Récompense gratuite disponible !
              </span>
            </p>
          </div>

          <div class="visit-date">
            Visité le {{ formatDate(visit.scanned_at) }}
          </div>
        </div>
      </div>
    </section>

    <div v-else-if="!visitsLoading" class="empty-state">
      <p>Vous n'avez pas encore visité de restaurant.</p>
      <p>Scannez un QR code pour commencer !</p>
    </div>

    <!-- Modal de notation -->
    <RestaurantRatingModal
      v-if="selectedRestaurant"
      :restaurant-id="selectedRestaurant.restaurant_id"
      :restaurant-name="selectedRestaurant.restaurant_name"
      :is-open="!!selectedRestaurant"
      @update:is-open="selectedRestaurant = null"
      @rating-updated="handleRatingUpdated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useQRScan } from '@/composables/useQRScan'
import { useRestaurantOrders, type RestaurantVisitWithOrder } from '@/composables/useRestaurantOrders'
import { useUserStore } from '@/stores/user'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'
import RestaurantRatingModal from '@/components/map/RestaurantRatingModal.vue'

type Restaurant = Database['public']['Tables']['restaurants']['Row']

const userStore = useUserStore()
const { recordVisit, isLoading, error: qrError } = useQRScan()
const { getVisitsWithOrders, isLoading: visitsLoading } = useRestaurantOrders()

const videoElement = ref<HTMLVideoElement | null>(null)
const isScanning = ref(false)
const error = ref<string | null>(null)
const successMessage = ref<string | null>(null)
const scannedRestaurant = ref<Restaurant | null>(null)
const visits = ref<RestaurantVisitWithOrder[]>([])
const selectedRestaurant = ref<RestaurantVisitWithOrder | null>(null)
let stream: MediaStream | null = null

const startScanning = async () => {
  try {
    error.value = null
    successMessage.value = null
    scannedRestaurant.value = null

    if (!userStore.user || userStore.user.role !== 'etudiant' || !userStore.user.id) {
      error.value = 'Vous devez être connecté en tant qu\'étudiant pour scanner un QR code'
      return
    }

    stream = await navigator.mediaDevices.getUserMedia({
      video: {
        facingMode: 'environment'
      }
    })

    if (videoElement.value) {
      videoElement.value.srcObject = stream
      isScanning.value = true

      if ('BarcodeDetector' in window) {
        const barcodeDetector = new (window as any).BarcodeDetector({
          formats: ['qr_code']
        })

        const detectQR = async () => {
          if (!videoElement.value || !isScanning.value) return

          try {
            const barcodes = await barcodeDetector.detect(videoElement.value)
            
            if (barcodes.length > 0) {
              const qrData = barcodes[0].rawValue
              await handleQRCode(qrData)
            } else {
              requestAnimationFrame(detectQR)
            }
          } catch (err) {
            console.error('Erreur lors de la détection:', err)
            requestAnimationFrame(detectQR)
          }
        }

        detectQR()
      } else {
        error.value = 'Votre navigateur ne supporte pas la lecture de QR code. Veuillez utiliser Chrome ou Edge récent.'
        stopScanning()
      }
    }
  } catch (err: any) {
    console.error('Erreur lors du démarrage du scan:', err)
    error.value = err.message || 'Erreur lors du démarrage du scan. Vérifiez que vous avez autorisé l\'accès à la caméra.'
    stopScanning()
  }
}

const stopScanning = () => {
  isScanning.value = false
  
  if (stream) {
    stream.getTracks().forEach(track => track.stop())
    stream = null
  }

  if (videoElement.value) {
    videoElement.value.srcObject = null
  }
}

const handleQRCode = async (qrData: string) => {
  if (!userStore.user?.id) return

  stopScanning()

  try {
    const visit = await recordVisit(userStore.user.id, qrData)

    if (visit) {
      const { data: restaurant } = await supabase
        .from('restaurants')
        .select('*')
        .eq('id', visit.restaurant_id)
        .single()

      if (restaurant) {
        scannedRestaurant.value = restaurant
        successMessage.value = 'Visite enregistrée avec succès !'
        
        // Recharger la liste des visites
        await loadVisits()
        
        setTimeout(() => {
          successMessage.value = null
          scannedRestaurant.value = null
        }, 5000)
      }
    } else {
      error.value = 'Visite déjà enregistrée aujourd\'hui pour ce restaurant'
    }
  } catch (err: any) {
    console.error('Erreur lors du traitement du QR code:', err)
    error.value = err.message || 'Erreur lors du traitement du QR code'
  }
}

const loadVisits = async () => {
  if (!userStore.user?.id) return
  visits.value = await getVisitsWithOrders(userStore.user.id)
}

const openRatingModal = (visit: RestaurantVisitWithOrder) => {
  selectedRestaurant.value = visit
}

const handleRatingUpdated = async () => {
  selectedRestaurant.value = null
  await loadVisits()
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(async () => {
  await loadVisits()
  
  if (!('BarcodeDetector' in window)) {
    console.warn('BarcodeDetector API not available')
  }
})

onUnmounted(() => {
  stopScanning()
})
</script>

<style scoped>
.ma-dalle-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: var(--foreground);
}

.page-title {
  margin-bottom: 2rem;
}

.scanner-section,
.visits-section {
  margin-bottom: 3rem;
}

.section-title {
  margin-bottom: 1.5rem;
}

.scanner-wrapper {
  position: relative;
  width: 100%;
  max-width: 500px;
  aspect-ratio: 1;
  border-radius: 1rem;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.5);
  margin: 0 auto;
}

.scanner-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.scanner-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;
}

.scanner-frame {
  width: 70%;
  height: 70%;
  border: 3px solid var(--primary);
  border-radius: 1rem;
  box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.5);
}

.stop-button {
  position: absolute;
  bottom: 1rem;
  left: 50%;
  transform: translateX(-50%);
  padding: 0.75rem 1.5rem;
  background: rgba(239, 68, 68, 0.9);
  color: var(--foreground);
  border: none;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.stop-button:hover {
  background: rgba(239, 68, 68, 1);
  transform: translateX(-50%) translateY(-2px);
}

.stop-button:active {
  transform: translateX(-50%) translateY(0);
  opacity: 0.8;
}

.scan-actions {
  display: flex;
  justify-content: center;
}

.start-button {
  padding: 1rem 2rem;
  background: var(--primary);
  color: var(--background);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1.1rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.1s;
}

.start-button:hover:not(:disabled) {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.start-button:active:not(:disabled) {
  transform: translate(0, 0);
  opacity: 0.8;
  box-shadow: 4px 4px 0 0 var(--black);
}

.start-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error-message {
  padding: 1rem;
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  border-radius: 0.5rem;
  color: #ffcccc;
  font-size: 0.9rem;
  text-align: center;
  max-width: 500px;
  margin: 0 auto 1rem;
}

.success-message {
  padding: 1rem;
  background: rgba(34, 197, 94, 0.2);
  border: 1px solid rgba(34, 197, 94, 0.5);
  border-radius: 0.5rem;
  color: #bbf7d0;
  font-size: 0.9rem;
  text-align: center;
  max-width: 500px;
  margin: 0 auto 1rem;
}

.loading-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 2rem;
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

.visits-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.visit-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 1.5rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.visit-header {
  margin-bottom: 1rem;
}

.restaurant-name {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0 0 0.5rem 0;
}

.restaurant-address {
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.7);
}

.rating-section {
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 0.75rem;
}

.existing-rating {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.rating-label {
  font-weight: 500;
}

.stars-display {
  display: flex;
  gap: 0.25rem;
}

.star {
  font-size: 1.2rem;
  opacity: 0.3;
  transition: opacity 0.2s;
}

.star.filled {
  opacity: 1;
}

.rating-value {
  font-weight: 600;
  color: #ffc107;
}

.rate-action {
  display: flex;
  justify-content: center;
}

.rate-button {
  padding: 0.75rem 1.5rem;
  background: var(--primary);
  color: var(--foreground);
  border: none;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.rate-button:hover {
  background: #5568d3;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.rate-button:active {
  transform: translateY(0);
  opacity: 0.8;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.no-rating {
  text-align: center;
}

.no-rating-text {
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
}

.reward-progress {
  margin-bottom: 1rem;
}

.progress-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.progress-label {
  font-size: 0.9rem;
  font-weight: 500;
}

.progress-count {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--primary);
}

.progress-bar-container {
  width: 100%;
  height: 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  overflow: hidden;
  margin-bottom: 0.5rem;
}

.progress-bar {
  height: 100%;
  background: linear-gradient(90deg, var(--primary) 0%, var(--yellow) 100%);
  border-radius: 6px;
  transition: width 0.3s ease;
}

.remaining-text {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.8);
  margin: 0;
}

.reward-ready {
  color: #ffc107;
  font-weight: 600;
}

.visit-date {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.empty-state {
  text-align: center;
  padding: 3rem 1rem;
  color: rgba(255, 255, 255, 0.7);
}

@media (max-width: 768px) {
  .ma-dalle-view {
    padding: 2rem 1rem;
  }

  .scanner-wrapper {
    max-width: 100%;
  }
}
</style>

