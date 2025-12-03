import { createClient } from '@supabase/supabase-js'
import * as dotenv from 'dotenv'
import { readFileSync } from 'fs'
import { join } from 'path'

// Charger les variables d'environnement
dotenv.config({ path: join(process.cwd(), '.env') })

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Variables d\'environnement Supabase non trouvées!')
  console.error('Assure-toi que le fichier .env contient VITE_SUPABASE_URL et VITE_SUPABASE_ANON_KEY')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function createTestData() {
  console.log('🚀 Création des données de test...\n')

  try {
    // 1. Créer l'utilisateur CLIENT
    console.log('1️⃣ Création du compte CLIENT...')
    const { data: clientAuth, error: clientAuthError } = await supabase.auth.signUp({
      email: 'client@test.com',
      password: 'test123456',
      options: {
        data: {
          role: 'client'
        }
      }
    })

    if (clientAuthError) {
      if (clientAuthError.message.includes('already registered')) {
        console.log('   ⚠️ Le compte client@test.com existe déjà')
        // Récupérer l'utilisateur existant
        const { data: existingClient } = await supabase.auth.signInWithPassword({
          email: 'client@test.com',
          password: 'test123456'
        })
        if (existingClient?.user) {
          clientAuth.user = existingClient.user
        }
      } else {
        throw clientAuthError
      }
    }

    if (clientAuth?.user) {
      const clientId = clientAuth.user.id
      console.log(`   ✅ Compte client créé (ID: ${clientId})`)

      // Créer le profil client
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: clientId,
          role: 'client',
          display_name: 'Client Test'
        })

      if (profileError && !profileError.message.includes('duplicate')) {
        console.error('   ❌ Erreur création profil:', profileError)
      } else {
        console.log('   ✅ Profil client créé')
      }

      // Créer les infos client
      const { error: clientError } = await supabase
        .from('clients')
        .upsert({
          id: clientId,
          age: 22,
          is_student: true,
          school_name: 'Sorbonne',
          main_arrondissement: '11ème',
          budget_range: '€€',
          favorite_categories: ['pizza', 'burger', 'sushi']
        })

      if (clientError && !clientError.message.includes('duplicate')) {
        console.error('   ❌ Erreur création données client:', clientError)
      } else {
        console.log('   ✅ Données client créées')
      }
    }

    console.log('')

    // 2. Créer l'utilisateur RESTAURANT
    console.log('2️⃣ Création du compte RESTAURANT...')
    const { data: restoAuth, error: restoAuthError } = await supabase.auth.signUp({
      email: 'resto@test.com',
      password: 'test123456',
      options: {
        data: {
          role: 'restaurant'
        }
      }
    })

    if (restoAuthError) {
      if (restoAuthError.message.includes('already registered')) {
        console.log('   ⚠️ Le compte resto@test.com existe déjà')
        // Récupérer l'utilisateur existant
        const { data: existingResto } = await supabase.auth.signInWithPassword({
          email: 'resto@test.com',
          password: 'test123456'
        })
        if (existingResto?.user) {
          restoAuth.user = existingResto.user
        }
      } else {
        throw restoAuthError
      }
    }

    if (restoAuth?.user) {
      const restoId = restoAuth.user.id
      console.log(`   ✅ Compte restaurant créé (ID: ${restoId})`)

      // Créer le profil restaurant
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: restoId,
          role: 'restaurant',
          display_name: 'Restaurant Test'
        })

      if (profileError && !profileError.message.includes('duplicate')) {
        console.error('   ❌ Erreur création profil:', profileError)
      } else {
        console.log('   ✅ Profil restaurant créé')
      }

      // Créer les infos restaurant
      const { error: restoError } = await supabase
        .from('restaurants')
        .upsert({
          id: restoId,
          name: 'Pizza Paradise Test',
          description: 'Restaurant de test - Pizzas artisanales au feu de bois',
          address: '123 rue de Test, 75011 Paris',
          arrondissement: '11ème',
          lat: 48.8566,
          lng: 2.3522,
          phone: '01 23 45 67 89',
          instagram: '@pizzaparadiseparis',
          price_level: '€€',
          cuisine_types: ['pizza', 'italian'],
          is_student_friendly: true,
          max_deals_per_day: 50
        })

      if (restoError && !restoError.message.includes('duplicate')) {
        console.error('   ❌ Erreur création données restaurant:', restoError)
      } else {
        console.log('   ✅ Données restaurant créées')
      }

      // Créer un deal pour le restaurant
      const { error: dealError } = await supabase
        .from('deals')
        .insert({
          restaurant_id: restoId,
          title: '1 Pizza = 1 Pizza offerte',
          description: 'Deal de test - Pizza au choix',
          deal_type: '1+1',
          category: 'pizza',
          min_group_size: 2,
          is_active: true,
          badge: '🔥 Populaire'
        })

      if (dealError) {
        console.error('   ❌ Erreur création deal:', dealError)
      } else {
        console.log('   ✅ Deal créé')
      }
    }

    console.log('\n✅ Données de test créées avec succès!')
    console.log('\n📋 Comptes créés:')
    console.log('   👤 Client: client@test.com / test123456')
    console.log('   🍕 Restaurant: resto@test.com / test123456')
    console.log('\n🔍 Vérifie dans Supabase → Table Editor pour voir les données!')

  } catch (error: any) {
    console.error('\n❌ Erreur:', error.message)
    console.error(error)
    process.exit(1)
  }
}

createTestData()

