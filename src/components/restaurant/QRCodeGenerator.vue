<template>
  <div class="qr-code-generator">
    <h3>QR Code du restaurant</h3>
    <p class="qr-instruction">Affichez ce QR code dans votre restaurant pour que les clients puissent scanner leur visite.</p>
    
    <div v-if="qrCodeData" class="qr-code-display">
      <div ref="qrCodeContainer" class="qr-code-container"></div>
      <button @click="downloadQRCode" class="download-button">Télécharger le QR code</button>
    </div>

    <div v-else class="loading-qr">
      <div class="spinner"></div>
      <p>Génération du QR code...</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useQRScan } from '@/composables/useQRScan'
import QRCode from 'qrcode'

interface Props {
  restaurantId: string
}

const props = defineProps<Props>()

const { generateQRCodeData } = useQRScan()
const qrCodeContainer = ref<HTMLElement | null>(null)
const qrCodeData = ref<string | null>(null)
const qrCodeImage = ref<string | null>(null)

const generateQRCode = async () => {
  if (!props.restaurantId) return

  try {
    // Générer les données du QR code
    const data = generateQRCodeData(props.restaurantId)
    qrCodeData.value = data

    // Générer l'image QR code
    if (qrCodeContainer.value) {
      const qrImage = await QRCode.toDataURL(data, {
        width: 300,
        margin: 2,
        color: {
          dark: '#000000',
          light: '#FFFFFF'
        }
      })
      
      qrCodeImage.value = qrImage
      
      if (qrCodeContainer.value) {
        qrCodeContainer.value.innerHTML = `<img src="${qrImage}" alt="QR Code" />`
      }
    }
  } catch (err) {
    console.error('Erreur lors de la génération du QR code:', err)
  }
}

const downloadQRCode = () => {
  if (!qrCodeImage.value) return

  const link = document.createElement('a')
  link.download = `qr-code-restaurant-${props.restaurantId}.png`
  link.href = qrCodeImage.value
  link.click()
}

watch(() => props.restaurantId, () => {
  generateQRCode()
})

onMounted(() => {
  generateQRCode()
})
</script>

<style scoped>
.qr-code-generator {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.qr-code-generator h3 {
  margin: 0 0 0.5rem 0;
  color: white;
  font-size: 1.25rem;
}

.qr-instruction {
  margin: 0 0 1.5rem 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
}

.qr-code-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.qr-code-container {
  padding: 1rem;
  background: white;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.qr-code-container img {
  max-width: 100%;
  height: auto;
}

.download-button {
  padding: 0.75rem 1.5rem;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.download-button:hover {
  background: #5568d3;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.loading-qr {
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

.loading-qr p {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
}
</style>

