import { ref } from 'vue'
import { supabase } from '@/lib/supabaseClient'
import { useUserStore } from '@/stores/user'
import type { Role } from '@/types/profile'

export function useAuth() {
  const userStore = useUserStore()
  const isLoading = ref(false)
  const errorMessage = ref<string | null>(null)

  // Connexion via les tables etudiants/restaurants
  const login = async (email: string, password: string) => {
    try {
      isLoading.value = true
      errorMessage.value = null

      // Validation des entrées
      if (!email || !password) {
        throw new Error('Veuillez remplir tous les champs')
      }

      // Normaliser l'email (minuscules, trim)
      const normalizedEmail = email.toLowerCase().trim()

      // 1. Chercher dans la table ETUDIANTS
      const { data: etudiant, error: etudiantError } = await supabase
        .from('etudiants')
        .select('*, profiles(role, display_name)')
        .eq('email', normalizedEmail)
        .eq('password', password)
        .maybeSingle()

      // Vérifier s'il y a une erreur de connexion (pas juste "pas trouvé")
      if (etudiantError && etudiantError.code !== 'PGRST116') {
        console.error('Erreur lors de la recherche de l\'étudiant:', etudiantError)
        throw new Error('Erreur lors de la connexion. Veuillez réessayer.')
      }

      if (etudiant) {
        const profile = Array.isArray(etudiant.profiles) ? etudiant.profiles[0] : etudiant.profiles

        // Connexion réussie en tant qu'ÉTUDIANT
        userStore.setUser({
          id: etudiant.id,
          username: profile?.display_name || `${etudiant.firstname || ''} ${etudiant.lastname || ''}`.trim() || 'Étudiant',
          email: etudiant.email || normalizedEmail,
          role: 'etudiant',
          points: 0,
          level: 1,
          badges: [],
          createdAt: new Date(etudiant.created_at),
        })

        // Sauvegarder la session dans localStorage
        localStorage.setItem('la_dalle_user', JSON.stringify({
          id: etudiant.id,
          role: 'etudiant',
          email: etudiant.email
        }))

        // La redirection sera gérée par le composant qui appelle login()
        return true
      }

      // 2. Chercher dans la table RESTAURANTS
      const { data: restaurant, error: restaurantError } = await supabase
        .from('restaurants')
        .select('*, profiles(role, display_name)')
        .eq('email', normalizedEmail)
        .eq('password', password)
        .maybeSingle()

      // Vérifier s'il y a une erreur de connexion (pas juste "pas trouvé")
      if (restaurantError && restaurantError.code !== 'PGRST116') {
        console.error('Erreur lors de la recherche du restaurant:', restaurantError)
        throw new Error('Erreur lors de la connexion. Veuillez réessayer.')
      }

      if (restaurant) {
        const profile = Array.isArray(restaurant.profiles) ? restaurant.profiles[0] : restaurant.profiles

        // Connexion réussie en tant que RESTAURANT
        userStore.setUser({
          id: restaurant.id,
          username: profile?.display_name || restaurant.name,
          email: restaurant.email || normalizedEmail,
          role: 'restaurant',
          points: 0,
          level: 1,
          badges: [],
          createdAt: new Date(restaurant.created_at),
        })

        // Sauvegarder la session dans localStorage
        localStorage.setItem('la_dalle_user', JSON.stringify({
          id: restaurant.id,
          role: 'restaurant',
          email: restaurant.email
        }))

        // La redirection sera gérée par le composant qui appelle login()
        return true
      }

      // Aucun utilisateur trouvé avec cet email et ce mot de passe
      throw new Error('Email ou mot de passe incorrect')

    } catch (err: unknown) {
      console.error('Erreur de connexion:', err)
      const error = err instanceof Error ? err : new Error('Erreur de connexion')
      errorMessage.value = error.message
      return false
    } finally {
      isLoading.value = false
    }
  }

  interface AdditionalSignupData {
    firstname?: string
    lastname?: string
    age?: number
    address?: string
    phone?: string
    ine?: string
    name?: string
    ownerFirstname?: string
    ownerLastname?: string
    description?: string
    logo?: string
    siren?: string
    siret?: string
    socialMedia?: string
    notifications?: {
      email?: boolean
      phone?: boolean
    }
  }

  // Inscription : créer directement dans les tables etudiants/restaurants
  const signup = async (
    email: string,
    password: string,
    role: Role,
    additionalData?: AdditionalSignupData
  ) => {
    try {
      isLoading.value = true
      errorMessage.value = null

      // Vérifier si l'email existe déjà
      const { data: existingEtudiant } = await supabase
        .from('etudiants')
        .select('id')
        .eq('email', email)
        .maybeSingle()

      const { data: existingResto } = await supabase
        .from('restaurants')
        .select('id')
        .eq('email', email)
        .maybeSingle()

      if (existingEtudiant || existingResto) {
        throw new Error('Cet email est déjà utilisé')
      }

      // Générer un UUID pour le nouvel utilisateur
      const newUserId = crypto.randomUUID()

      // Créer le profil
      const displayName = role === 'etudiant'
        ? `${additionalData?.firstname || ''} ${additionalData?.lastname || ''}`.trim()
        : additionalData?.name || 'Nouveau Restaurant'

      const { error: profileError } = await supabase
        .from('profiles')
        .insert({
          id: newUserId,
          role,
          display_name: displayName || null,
        })

      if (profileError) throw profileError

      // Créer dans la table appropriée selon le rôle
      if (role === 'etudiant') {
        // Vérifier que le N° INE est fourni (obligatoire pour les étudiants)
        if (!additionalData?.ine) {
          throw new Error('Le N° INE est obligatoire pour s\'inscrire en tant qu\'étudiant')
        }

        const { error: etudiantError } = await supabase
          .from('etudiants')
          .insert({
            id: newUserId,
            email,
            password, // En production, il faudrait hasher le mot de passe
            firstname: additionalData?.firstname || null,
            lastname: additionalData?.lastname || null,
            age: additionalData?.age || null,
            address: additionalData?.address || null,
            phone: additionalData?.phone || null,
            ine: additionalData?.ine || null,
            is_student: true, // Tous les étudiants sont des étudiants
            notifications_email: additionalData?.notifications?.email || false,
            notifications_phone: additionalData?.notifications?.phone || false,
          })

        if (etudiantError) throw etudiantError

        // Si une adresse est fournie, créer une entrée dans etudiant_addresses comme adresse par défaut
        if (additionalData?.address) {
          // Géocoder l'adresse pour obtenir les coordonnées
          let coords: { lat: number; lng: number } | null = null
          try {
            const response = await fetch(
              `https://api-adresse.data.gouv.fr/search/?q=${encodeURIComponent(additionalData.address)}&limit=1`
            )
            const data = await response.json()
            if (data.features && data.features.length > 0) {
              const [lng, lat] = data.features[0].geometry.coordinates
              coords = { lat, lng }
            }
          } catch (geocodeError) {
            console.warn('Erreur lors du géocodage de l\'adresse:', geocodeError)
            // On continue même si le géocodage échoue
          }

          // Créer l'adresse par défaut dans etudiant_addresses
          const { error: addressError } = await supabase
            .from('etudiant_addresses')
            .insert({
              etudiant_id: newUserId,
              address: additionalData.address,
              lat: coords?.lat || null,
              lng: coords?.lng || null,
              is_default: true,
              label: 'Adresse par défaut'
            })

          if (addressError) {
            console.warn('Erreur lors de la création de l\'adresse par défaut:', addressError)
            // On ne fait pas échouer l'inscription si l'adresse ne peut pas être créée
          }
        }
      } else {
        const { error: restoError } = await supabase
          .from('restaurants')
          .insert({
            id: newUserId,
            name: additionalData?.name || 'Nouveau Restaurant',
            email,
            password, // En production, il faudrait hasher le mot de passe
            owner_firstname: additionalData?.ownerFirstname || null,
            owner_lastname: additionalData?.ownerLastname || null,
            address: additionalData?.address || null,
            description: additionalData?.description || null,
            logo: additionalData?.logo || null,
            siren: additionalData?.siren || null,
            siret: additionalData?.siret || null,
            social_media: additionalData?.socialMedia || null,
            phone: additionalData?.phone || null,
            notifications_email: additionalData?.notifications?.email || false,
            notifications_phone: additionalData?.notifications?.phone || false,
          })

        if (restoError) throw restoError
      }

      return true
    } catch (err: unknown) {
      console.error(err)
      const error = err instanceof Error ? err : new Error('Erreur d\'inscription')
      errorMessage.value = error.message
      return false
    } finally {
      isLoading.value = false
    }
  }

  // Charger le profil utilisateur depuis les tables etudiants/restaurants
  const loadUserProfile = async (userId: string, userRole: Role) => {
    if (userRole === 'etudiant') {
      const { data: etudiant, error } = await supabase
        .from('etudiants')
        .select('*, profiles(role, display_name)')
        .eq('id', userId)
        .single()

      if (error) throw error
      if (!etudiant) throw new Error('Profil étudiant non trouvé')

      const profile = Array.isArray(etudiant.profiles) ? etudiant.profiles[0] : etudiant.profiles

      userStore.setUser({
        id: etudiant.id,
        username: profile?.display_name || 'Étudiant',
        email: etudiant.email || '',
        role: 'etudiant',
        points: 0,
        level: 1,
        badges: [],
        createdAt: new Date(etudiant.created_at),
      })
    } else {
      const { data: restaurant, error } = await supabase
        .from('restaurants')
        .select('*, profiles(role, display_name)')
        .eq('id', userId)
        .single()

      if (error) throw error
      if (!restaurant) throw new Error('Profil restaurant non trouvé')

      const profile = Array.isArray(restaurant.profiles) ? restaurant.profiles[0] : restaurant.profiles

      userStore.setUser({
        id: restaurant.id,
        username: profile?.display_name || restaurant.name,
        email: restaurant.email || '',
        role: 'restaurant',
        points: 0,
        level: 1,
        badges: [],
        createdAt: new Date(restaurant.created_at),
      })
    }
  }

  // Vérifier la session au chargement (depuis localStorage)
  const checkSession = async () => {
    const savedUser = localStorage.getItem('la_dalle_user')

    if (savedUser) {
      try {
        const userData = JSON.parse(savedUser)
        await loadUserProfile(userData.id, userData.role)
      } catch (error) {
        console.error('Erreur lors du chargement de la session:', error)
        localStorage.removeItem('la_dalle_user')
      }
    }
  }

  // Mode test : connexion étudiant rapide (utilise les vraies données de la BD)
  const loginTestClient = async () => {
    const success = await login('client@test.com', 'test123456')
    if (!success) {
      // Fallback si la connexion échoue
      userStore.setUser({
        id: 'test-etudiant',
        username: 'Étudiant Test',
        email: 'client@test.com',
        role: 'etudiant',
        points: 200,
        level: 2,
        badges: [],
        createdAt: new Date(),
      })
      // La redirection sera gérée par le composant qui appelle loginTestClient()
    }
  }

  // Mode test : connexion restaurant rapide (utilise les vraies données de la BD)
  const loginTestRestaurant = async () => {
    const success = await login('resto@test.com', 'test123456')
    if (!success) {
      // Fallback si la connexion échoue
      userStore.setUser({
        id: 'test-restaurant',
        username: 'Restaurant Test',
        email: 'resto@test.com',
        role: 'restaurant',
        points: 0,
        level: 1,
        badges: [],
        createdAt: new Date(),
      })
      // La redirection sera gérée par le composant qui appelle loginTestRestaurant()
    }
  }

  const logout = async () => {
    localStorage.removeItem('la_dalle_user')
    userStore.clearUser()
  }

  const isAuthenticated = () => {
    return !!userStore.user?.id
  }

  const getRole = () => {
    return userStore.user?.role || null
  }

  return {
    user: userStore.user,
    isLoading,
    errorMessage,
    login,
    signup,
    logout,
    isAuthenticated,
    getRole,
    loginTestClient,
    loginTestRestaurant,
    checkSession,
  }
}

