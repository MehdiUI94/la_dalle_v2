import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'

export interface EtudiantAddress {
  id: string
  etudiant_id: string
  address: string
  lat: number | null
  lng: number | null
  is_default: boolean
  label: string | null
  created_at: string
  updated_at: string
}

export const useLocationStore = defineStore('location', () => {
  const defaultLocation = ref<string | null>(null)
  const defaultCoordinates = ref<{ lat: number; lng: number } | null>(null)
  const temporaryLocation = ref<string | null>(null)
  const temporaryCoordinates = ref<{ lat: number; lng: number } | null>(null)
  const addresses = ref<EtudiantAddress[]>([])
  const selectedAddressId = ref<string | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Charger toutes les adresses de l'étudiant
  const loadAddresses = async (userId: string) => {
    try {
      isLoading.value = true
      error.value = null

      // Charger les adresses depuis la table etudiant_addresses
      const { data: etudiantAddresses, error: addressesError } = await supabase
        .from('etudiant_addresses')
        .select('*')
        .eq('etudiant_id', userId)
        .order('is_default', { ascending: false })
        .order('created_at', { ascending: false })

      if (addressesError) throw addressesError

      addresses.value = (etudiantAddresses || []) as EtudiantAddress[]

      // Trouver l'adresse par défaut
      const defaultAddr = addresses.value.find(addr => addr.is_default)
      if (defaultAddr) {
        defaultLocation.value = defaultAddr.address
        if (defaultAddr.lat && defaultAddr.lng) {
          defaultCoordinates.value = { lat: defaultAddr.lat, lng: defaultAddr.lng }
        } else {
          // Géocoder si pas de coordonnées
          const coords = await geocodeAddress(defaultAddr.address)
          if (coords) {
            defaultCoordinates.value = coords
            // Mettre à jour les coordonnées en base
            await supabase
              .from('etudiant_addresses')
              .update({ lat: coords.lat, lng: coords.lng })
              .eq('id', defaultAddr.id)
          }
        }
        selectedAddressId.value = defaultAddr.id
      } else if (addresses.value.length > 0) {
        // Si pas d'adresse par défaut, utiliser la première
        const firstAddr = addresses.value[0]
        defaultLocation.value = firstAddr.address
        if (firstAddr.lat && firstAddr.lng) {
          defaultCoordinates.value = { lat: firstAddr.lat, lng: firstAddr.lng }
        }
        selectedAddressId.value = firstAddr.id
      } else {
        // Fallback : charger depuis la table etudiants (ancienne méthode)
        const { data: etudiant, error: etudiantError } = await supabase
          .from('etudiants')
          .select('address')
          .eq('id', userId)
          .single()

        if (!etudiantError && etudiant?.address) {
          defaultLocation.value = etudiant.address
          const coords = await geocodeAddress(etudiant.address)
          if (coords) {
            defaultCoordinates.value = coords
          }
        }
      }
    } catch (err: unknown) {
      console.error('Erreur lors du chargement des adresses:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors du chargement des adresses')
      error.value = error.message
    } finally {
      isLoading.value = false
    }
  }

  // Charger la localisation par défaut depuis la base de données (méthode legacy)
  const loadDefaultLocation = async (userId: string) => {
    await loadAddresses(userId)
  }

  // Convertir une adresse en coordonnées géographiques
  const geocodeAddress = async (address: string): Promise<{ lat: number; lng: number } | null> => {
    try {
      const response = await fetch(
        `https://api-adresse.data.gouv.fr/search/?q=${encodeURIComponent(address)}&limit=1`
      )
      const data = await response.json()

      if (data.features && data.features.length > 0) {
        const [lng, lat] = data.features[0].geometry.coordinates
        return { lat, lng }
      }
      return null
    } catch (err) {
      console.error('Erreur lors du géocodage:', err)
      return null
    }
  }

  // Définir une localisation temporaire
  const setTemporaryLocation = async (address: string) => {
    temporaryLocation.value = address
    const coords = await geocodeAddress(address)
    if (coords) {
      temporaryCoordinates.value = coords
    }
  }

  // Réinitialiser à la localisation par défaut
  const resetToDefault = () => {
    temporaryLocation.value = null
    temporaryCoordinates.value = null
  }

  // Obtenir les coordonnées actuelles (temporaire ou par défaut)
  const getCurrentCoordinates = (): { lat: number; lng: number } | null => {
    if (temporaryCoordinates.value) return temporaryCoordinates.value
    
    // Si une adresse est sélectionnée, utiliser ses coordonnées
    if (selectedAddressId.value) {
      const selectedAddr = addresses.value.find(addr => addr.id === selectedAddressId.value)
      if (selectedAddr?.lat && selectedAddr?.lng) {
        return { lat: selectedAddr.lat, lng: selectedAddr.lng }
      }
    }
    
    return defaultCoordinates.value
  }

  // Obtenir l'adresse actuelle (temporaire ou par défaut)
  const getCurrentAddress = (): string | null => {
    if (temporaryLocation.value) return temporaryLocation.value
    
    // Si une adresse est sélectionnée, utiliser son adresse
    if (selectedAddressId.value) {
      const selectedAddr = addresses.value.find(addr => addr.id === selectedAddressId.value)
      if (selectedAddr) return selectedAddr.address
    }
    
    return defaultLocation.value
  }

  // Ajouter une nouvelle adresse
  const addAddress = async (userId: string, address: string, label: string | null = null, isDefault: boolean = false) => {
    try {
      isLoading.value = true
      error.value = null

      // Géocoder l'adresse
      const coords = await geocodeAddress(address)
      
      // Si on définit comme par défaut, retirer le statut par défaut des autres
      if (isDefault) {
        await supabase
          .from('etudiant_addresses')
          .update({ is_default: false })
          .eq('etudiant_id', userId)
      }

      // Insérer la nouvelle adresse
      const { data, error: insertError } = await supabase
        .from('etudiant_addresses')
        .insert({
          etudiant_id: userId,
          address,
          lat: coords?.lat || null,
          lng: coords?.lng || null,
          is_default: isDefault,
          label
        })
        .select()
        .single()

      if (insertError) throw insertError

      // Recharger les adresses
      await loadAddresses(userId)

      return data
    } catch (err: unknown) {
      console.error('Erreur lors de l\'ajout de l\'adresse:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de l\'ajout de l\'adresse')
      error.value = error.message
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // Définir une adresse comme par défaut
  const setDefaultAddress = async (userId: string, addressId: string) => {
    try {
      isLoading.value = true
      error.value = null

      // Retirer le statut par défaut de toutes les adresses
      await supabase
        .from('etudiant_addresses')
        .update({ is_default: false })
        .eq('etudiant_id', userId)

      // Définir la nouvelle adresse par défaut
      const { error: updateError } = await supabase
        .from('etudiant_addresses')
        .update({ is_default: true })
        .eq('id', addressId)

      if (updateError) throw updateError

      // Recharger les adresses
      await loadAddresses(userId)
    } catch (err: unknown) {
      console.error('Erreur lors de la définition de l\'adresse par défaut:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la définition de l\'adresse par défaut')
      error.value = error.message
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // Supprimer une adresse
  const deleteAddress = async (addressId: string, userId: string) => {
    try {
      isLoading.value = true
      error.value = null

      const { error: deleteError } = await supabase
        .from('etudiant_addresses')
        .delete()
        .eq('id', addressId)

      if (deleteError) throw deleteError

      // Recharger les adresses
      await loadAddresses(userId)
    } catch (err: unknown) {
      console.error('Erreur lors de la suppression de l\'adresse:', err)
      const error = err instanceof Error ? err : new Error('Erreur lors de la suppression de l\'adresse')
      error.value = error.message
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // Sélectionner une adresse (pour utilisation temporaire)
  const selectAddress = (addressId: string) => {
    const address = addresses.value.find(addr => addr.id === addressId)
    if (address) {
      selectedAddressId.value = addressId
      temporaryLocation.value = null
      temporaryCoordinates.value = null
    }
  }

  return {
    defaultLocation,
    defaultCoordinates,
    temporaryLocation,
    temporaryCoordinates,
    addresses,
    selectedAddressId,
    isLoading,
    error,
    loadDefaultLocation,
    loadAddresses,
    setTemporaryLocation,
    resetToDefault,
    getCurrentCoordinates,
    getCurrentAddress,
    geocodeAddress,
    addAddress,
    setDefaultAddress,
    deleteAddress,
    selectAddress
  }
})

