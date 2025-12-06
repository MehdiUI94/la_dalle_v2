import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabaseClient'
import { useUserStore } from '@/stores/user'
import type { Role } from '@/types/profile'

export function useAuth() {
  const userStore = useUserStore()
  const router = useRouter()
  const isLoading = ref(false)
  const errorMessage = ref<string | null>(null)

  // Connexion via les tables clients/restaurants
  const login = async (email: string, password: string) => {
    try {
      isLoading.value = true
      errorMessage.value = null

      // 1. Chercher dans la table CLIENTS
      const { data: client, error: clientError } = await supabase
        .from('clients')
        .select('*, profiles(role, display_name)')
        .eq('email', email)
        .eq('password', password)
        .maybeSingle()

      if (client && !clientError) {
        const profile = Array.isArray(client.profiles) ? client.profiles[0] : client.profiles

        // Connexion réussie en tant que CLIENT
        userStore.setUser({
          id: client.id,
          username: profile?.display_name || 'Client',
          email: client.email || email,
          role: 'client',
          points: 0,
          level: 1,
          badges: [],
          createdAt: new Date(client.created_at),
        })

        // Sauvegarder la session dans localStorage
        localStorage.setItem('la_dalle_user', JSON.stringify({
          id: client.id,
          role: 'client',
          email: client.email
        }))

        router.push('/deals')
        return true
      }

      // 2. Chercher dans la table RESTAURANTS
      const { data: restaurant, error: restaurantError } = await supabase
        .from('restaurants')
        .select('*, profiles(role, display_name)')
        .eq('email', email)
        .eq('password', password)
        .maybeSingle()

      if (restaurant && !restaurantError) {
        const profile = Array.isArray(restaurant.profiles) ? restaurant.profiles[0] : restaurant.profiles

        // Connexion réussie en tant que RESTAURANT
        userStore.setUser({
          id: restaurant.id,
          username: profile?.display_name || restaurant.name,
          email: restaurant.email || email,
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

        router.push('/dashboard/restaurant')
        return true
      }

      // Aucun utilisateur trouvé
      throw new Error('Email ou mot de passe incorrect')

    } catch (err: any) {
      console.error(err)
      errorMessage.value = err.message ?? 'Erreur de connexion'
      return false
    } finally {
      isLoading.value = false
    }
  }

  // Inscription : créer directement dans les tables clients/restaurants
  const signup = async (
    email: string,
    password: string,
    role: Role,
    additionalData?: any
  ) => {
    try {
      isLoading.value = true
      errorMessage.value = null

      // Vérifier si l'email existe déjà
      const { data: existingClient } = await supabase
        .from('clients')
        .select('id')
        .eq('email', email)
        .maybeSingle()

      const { data: existingResto } = await supabase
        .from('restaurants')
        .select('id')
        .eq('email', email)
        .maybeSingle()

      if (existingClient || existingResto) {
        throw new Error('Cet email est déjà utilisé')
      }

      // Générer un UUID pour le nouvel utilisateur
      const newUserId = crypto.randomUUID()

      // Créer le profil
      const displayName = role === 'client'
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
      if (role === 'client') {
        // Vérifier que le N° INE est fourni (obligatoire pour les étudiants)
        if (!additionalData?.ine) {
          throw new Error('Le N° INE est obligatoire pour s\'inscrire en tant qu\'étudiant')
        }

        const { error: clientError } = await supabase
          .from('clients')
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
            is_student: true, // Tous les clients sont des étudiants
            notifications_email: additionalData?.notifications?.email || false,
            notifications_phone: additionalData?.notifications?.phone || false,
          })

        if (clientError) throw clientError
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
    } catch (err: any) {
      console.error(err)
      errorMessage.value = err.message ?? 'Erreur d\'inscription'
      return false
    } finally {
      isLoading.value = false
    }
  }

  // Charger le profil utilisateur depuis les tables clients/restaurants
  const loadUserProfile = async (userId: string, userRole: Role) => {
    if (userRole === 'client') {
      const { data: client, error } = await supabase
        .from('clients')
        .select('*, profiles(role, display_name)')
        .eq('id', userId)
        .single()

      if (error) throw error
      if (!client) throw new Error('Profil client non trouvé')

      const profile = Array.isArray(client.profiles) ? client.profiles[0] : client.profiles

      userStore.setUser({
        id: client.id,
        username: profile?.display_name || 'Client',
        email: client.email || '',
        role: 'client',
        points: 0,
        level: 1,
        badges: [],
        createdAt: new Date(client.created_at),
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

  // Mode test : connexion client rapide (utilise les vraies données de la BD)
  const loginTestClient = async () => {
    const success = await login('client@test.com', 'test123456')
    if (!success) {
      // Fallback si la connexion échoue
      userStore.setTestUser({
        id: 'test-client',
        username: 'Client Test',
        email: 'client@test.com',
        role: 'client',
        points: 200,
        level: 2,
        badges: [],
        createdAt: new Date(),
      })
      router.push('/deals')
    }
  }

  // Mode test : connexion restaurant rapide (utilise les vraies données de la BD)
  const loginTestRestaurant = async () => {
    const success = await login('resto@test.com', 'test123456')
    if (!success) {
      // Fallback si la connexion échoue
      userStore.setTestUser({
        id: 'test-restaurant',
        username: 'Restaurant Test',
        email: 'resto@test.com',
        role: 'restaurant',
        points: 0,
        level: 1,
        badges: [],
        createdAt: new Date(),
      })
      router.push('/dashboard/restaurant')
    }
  }

  const logout = async () => {
    localStorage.removeItem('la_dalle_user')
    userStore.clearUser()
    router.push('/')
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

