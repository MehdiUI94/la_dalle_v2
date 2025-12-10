<template>
  <div class="image-input">
    <label :for="inputId">{{ label }} <span v-if="optional" class="optional-label">(optionnel)</span></label>
    
    <div class="image-input-tabs">
      <button
        type="button"
        :class="['tab', { active: inputMode === 'url' }]"
        @click="inputMode = 'url'"
      >
        URL
      </button>
      <button
        type="button"
        :class="['tab', { active: inputMode === 'upload' }]"
        @click="inputMode = 'upload'"
      >
        Fichier
      </button>
    </div>

    <div v-if="inputMode === 'url'" class="url-input">
      <input
        :id="inputId"
        v-model="urlValue"
        type="url"
        :placeholder="urlPlaceholder"
        @input="handleUrlChange"
        class="url-input-field"
      />
      <div v-if="urlValue && isValidUrl(urlValue)" class="url-preview">
        <img :src="urlValue" alt="Preview" @error="handleImageError" />
      </div>
    </div>

    <div v-else class="upload-input">
      <input
        :id="`${inputId}-file`"
        ref="fileInputRef"
        type="file"
        accept="image/jpeg,image/jpg,image/png,image/webp,image/gif"
        @change="handleFileChange"
        style="display: none"
      />
      <div class="upload-area" @click="triggerFileInput">
        <div v-if="!previewUrl && !isUploading" class="upload-placeholder">
          <span class="upload-icon">📷</span>
          <span>Cliquez pour sélectionner une image</span>
          <small>JPEG, PNG, WebP ou GIF (max 5 Mo)</small>
        </div>
        <div v-if="isUploading" class="upload-loading">
          <div class="spinner"></div>
          <span>Upload en cours... {{ uploadProgress }}%</span>
        </div>
        <div v-if="previewUrl && !isUploading" class="upload-preview">
          <img :src="previewUrl" alt="Preview" />
          <button type="button" class="remove-image" @click.stop="removeImage">✕</button>
        </div>
      </div>
      <p v-if="localUploadError || uploadError" class="error-message">{{ localUploadError || uploadError }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useImageUpload } from '@/composables/useImageUpload'

interface Props {
  modelValue: string | null
  label: string
  inputId: string
  urlPlaceholder?: string
  optional?: boolean
  folder?: string
}

const props = withDefaults(defineProps<Props>(), {
  urlPlaceholder: 'https://exemple.com/image.png',
  optional: false,
  folder: 'logos'
})

const emit = defineEmits<{
  'update:modelValue': [value: string | null]
}>()

const inputMode = ref<'url' | 'upload'>('url')
const fileInputRef = ref<HTMLInputElement | null>(null)
const urlValue = ref(props.modelValue || '')
const previewUrl = ref<string | null>(props.modelValue || null)

const { uploadImage, validateImageFile, isUploading, uploadError, uploadProgress, clearError } = useImageUpload()

const localUploadError = ref<string | null>(null)

const isValidUrl = (url: string): boolean => {
  try {
    new URL(url)
    return true
  } catch {
    return false
  }
}

const handleImageError = () => {
  previewUrl.value = null
}

const handleUrlChange = () => {
  previewUrl.value = urlValue.value || null
  emit('update:modelValue', urlValue.value || null)
}

const triggerFileInput = () => {
  fileInputRef.value?.click()
}

const handleFileChange = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]

  if (!file) return

  localUploadError.value = null
  clearError()
  const validation = validateImageFile(file)
  if (!validation.valid) {
    localUploadError.value = validation.error || 'Fichier invalide'
    return
  }

  const objectUrl = URL.createObjectURL(file)
  previewUrl.value = objectUrl

  const uploadedUrl = await uploadImage(file, props.folder)
  
  if (uploadedUrl) {
    URL.revokeObjectURL(objectUrl)
    previewUrl.value = uploadedUrl
    emit('update:modelValue', uploadedUrl)
    localUploadError.value = null
  } else {
    URL.revokeObjectURL(objectUrl)
    previewUrl.value = null
    localUploadError.value = uploadError.value || 'Erreur lors de l\'upload'
  }
}

const removeImage = () => {
  previewUrl.value = null
  urlValue.value = ''
  if (fileInputRef.value) {
    fileInputRef.value.value = ''
  }
  emit('update:modelValue', null)
}

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    urlValue.value = newValue
    previewUrl.value = newValue
    if (newValue.startsWith('http')) {
      inputMode.value = 'url'
    } else {
      inputMode.value = 'upload'
    }
  }
})
</script>

<style scoped>
.image-input {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.image-input-tabs {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.tab {
  flex: 1;
  padding: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
  border-radius: 0.375rem;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 0.9rem;
}

.tab:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
}

.tab.active {
  background: white;
  color: var(--primary);
  border-color: white;
}

.url-input {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.url-input-field {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  border-radius: 0.5rem;
  color: white;
  font-size: 1rem;
}

.url-preview {
  margin-top: 0.5rem;
}

.url-preview img {
  max-width: 200px;
  max-height: 200px;
  border-radius: 0.5rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.upload-area {
  border: 2px dashed rgba(255, 255, 255, 0.3);
  border-radius: 0.5rem;
  padding: 2rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s;
  background: rgba(255, 255, 255, 0.05);
}

.upload-area:hover {
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.1);
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: rgba(255, 255, 255, 0.7);
}

.upload-icon {
  font-size: 2rem;
}

.upload-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  color: rgba(255, 255, 255, 0.9);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.upload-preview {
  position: relative;
  display: inline-block;
}

.upload-preview img {
  max-width: 200px;
  max-height: 200px;
  border-radius: 0.5rem;
}

.remove-image {
  position: absolute;
  top: -10px;
  right: -10px;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(239, 68, 68, 0.9);
  color: white;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.error-message {
  color: #ffcccc;
  font-size: 0.875rem;
  margin-top: 0.5rem;
}

.optional-label {
  font-style: italic;
  font-weight: normal;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9em;
}
</style>
