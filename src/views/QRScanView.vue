<template>
  <div class="qr-scan-view">
    <BackButton />
    <div class="scan-container">
      <h2 class="scan-title">Scanner le QR code du restaurant</h2>
      
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
          <span v-else>Démarrer le scan</span>
        </button>
      </div>

      <div v-if="scannedRestaurant" class="scanned-restaurant-info">
        <h3>Visite enregistrée !</h3>
        <p><strong>{{ scannedRestaurant.name }}</strong></p>
        <p v-if="scannedRestaurant.address">{{ scannedRestaurant.address }}</p>
        <p class="success-note">Vous recevrez une notification dans 30 minutes pour noter ce restaurant.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useQRScan } from '@/composables/useQRScan'
import { useUserStore } from '@/stores/user'
import { supabase } from '@/lib/supabaseClient'
import type { Database } from '@/types/database'
import BackButton from '@/components/shared/BackButton.vue'

type Restaurant = Database['public']['Tables']['restaurants']['Row']

const userStore = useUserStore()
const { recordVisit, isLoading, error: qrError } = useQRScan()

const videoElement = ref<HTMLVideoElement | null>(null)
const isScanning = ref(false)
const error = ref<string | null>(null)
const successMessage = ref<string | null>(null)
const scannedRestaurant = ref<Restaurant | null>(null)
let stream: MediaStream | null = null
let codeReader: any = null

const startScanning = async () => {
  try {
    error.value = null
    successMessage.value = null
    scannedRestaurant.value = null

    // Vérifier que l'utilisateur est un étudiant
    if (!userStore.user || userStore.user.role !== 'etudiant' || !userStore.user.id) {
      error.value = 'Vous devez être connecté en tant qu\'étudiant pour scanner un QR code'
      return
    }

    // Demander l'accès à la caméra
    stream = await navigator.mediaDevices.getUserMedia({
      video: {
        facingMode: 'environment' // Caméra arrière sur mobile
      }
    })

    if (videoElement.value) {
      videoElement.value.srcObject = stream
      isScanning.value = true

      // Utiliser l'API native de lecture de QR code du navigateur
      // Note: Cette API est disponible dans Chrome/Edge récents
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
              // Continuer à scanner
              requestAnimationFrame(detectQR)
            }
          } catch (err) {
            console.error('Erreur lors de la détection:', err)
            requestAnimationFrame(detectQR)
          }
        }

        detectQR()
      } else {
        // Fallback: utiliser une bibliothèque externe si nécessaire
        // Pour l'instant, on affiche un message d'erreur
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
    // Enregistrer la visite
    const visit = await recordVisit(userStore.user.id, qrData)

    if (visit) {
      // Récupérer les informations du restaurant
      const { data: restaurant, error: restaurantError } = await supabase
        .from('restaurants')
        .select('*')
        .eq('id', visit.restaurant_id)
        .single()

      if (restaurantError) throw restaurantError

      scannedRestaurant.value = restaurant
      successMessage.value = 'Visite enregistrée avec succès !'
      
      // Réinitialiser après 5 secondes
      setTimeout(() => {
        successMessage.value = null
        scannedRestaurant.value = null
      }, 5000)
    } else {
      error.value = 'Visite déjà enregistrée aujourd\'hui pour ce restaurant'
    }
  } catch (err: any) {
    console.error('Erreur lors du traitement du QR code:', err)
    error.value = err.message || 'Erreur lors du traitement du QR code'
  }
}

onMounted(() => {
  // Vérifier si l'API BarcodeDetector est disponible
  if (!('BarcodeDetector' in window)) {
    console.warn('BarcodeDetector API not available')
  }
})

onUnmounted(() => {
  stopScanning()
})
</script>

<style scoped>
.qr-scan-view {
  padding: 2rem 80px;
  min-height: calc(100vh - 140px);
  color: white;
  max-width: 1200px;
  margin: 0 auto;
}

.scan-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
}

.scan-title {
  font-size: 1.75rem;
  font-weight: 600;
  margin: 0;
  text-align: center;
}

.scanner-wrapper {
  position: relative;
  width: 100%;
  max-width: 500px;
  aspect-ratio: 1;
  border-radius: 1rem;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.5);
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
  border: 3px solid #667eea;
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
  color: white;
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
  background: #667eea;
  color: white;
  border: none;
  border-radius: 0.75rem;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.start-button:hover:not(:disabled) {
  background: #5568d3;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.start-button:active:not(:disabled) {
  transform: translateY(0);
  opacity: 0.8;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
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
}

.scanned-restaurant-info {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  text-align: center;
  max-width: 500px;
}

.scanned-restaurant-info h3 {
  margin: 0 0 1rem 0;
  font-size: 1.25rem;
  color: #bbf7d0;
}

.scanned-restaurant-info p {
  margin: 0.5rem 0;
  font-size: 1rem;
}

.success-note {
  margin-top: 1rem !important;
  font-size: 0.9rem !important;
  color: rgba(255, 255, 255, 0.7);
  font-style: italic;
}

@media (max-width: 768px) {
  .qr-scan-view {
    padding: 2rem 1rem;
  }
}
</style>

