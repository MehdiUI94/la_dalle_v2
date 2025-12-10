import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'

export function useImageUpload() {
  const isUploading = ref(false)
  const uploadError = ref<string | null>(null)
  const uploadProgress = ref(0)

  const clearError = () => {
    uploadError.value = null
  }

  const uploadImage = async (file: File, folder: string = 'logos'): Promise<string | null> => {
    try {
      isUploading.value = true
      uploadError.value = null
      uploadProgress.value = 0

      const fileExt = file.name.split('.').pop()
      const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`
      const filePath = `${folder}/${fileName}`

      const { data, error } = await supabase.storage
        .from('images')
        .upload(filePath, file, {
          cacheControl: '3600',
          upsert: false
        })

      if (error) throw error

      const { data: { publicUrl } } = supabase.storage
        .from('images')
        .getPublicUrl(filePath)

      uploadProgress.value = 100
      return publicUrl
    } catch (error: unknown) {
      console.error('Erreur lors de l\'upload:', error)
      const err = error instanceof Error ? error : new Error('Erreur lors de l\'upload de l\'image')
      uploadError.value = err.message
      return null
    } finally {
      isUploading.value = false
    }
  }

  const validateImageFile = (file: File): { valid: boolean; error?: string } => {
    const maxSize = 5 * 1024 * 1024
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif']

    if (!allowedTypes.includes(file.type)) {
      return {
        valid: false,
        error: 'Format non supporté. Utilisez JPEG, PNG, WebP ou GIF.'
      }
    }

    if (file.size > maxSize) {
      return {
        valid: false,
        error: 'L\'image est trop volumineuse. Taille maximum : 5 Mo.'
      }
    }

    return { valid: true }
  }

  return {
    uploadImage,
    validateImageFile,
    isUploading,
    uploadError,
    uploadProgress,
    clearError
  }
}

