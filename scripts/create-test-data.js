import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Charger les variables d'environnement depuis .env
function loadEnv() {
  try {
    const envFile = readFileSync(join(__dirname, '..', '.env'), 'utf-8')
    const env = {}
    envFile.split('\n').forEach(line => {
      const [key, ...valueParts] = line.split('=')
      if (key && valueParts.length > 0) {
        env[key.trim()] = valueParts.join('=').trim()
      }
    })
    return env
  } catch (error) {
    console.error('❌ Erreur lecture .env:', error.message)
    process.exit(1)
  }
}

const env = loadEnv()
const supabaseUrl = env.VITE_SUPABASE_URL
const supabaseAnonKey = env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Variables d\'environnement Supabase non trouvées!')
  console.error('Assure-toi que le fichier .env contient VITE_SUPABASE_URL et VITE_SUPABASE_ANON_KEY')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function createTestData() {
  console.log('🚀 Création des données de test dans Supabase...\n')

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

    let clientId = null

    if (clientAuthError) {
      if (clientAuthError.message.includes('already registered') || clientAuthError.message.includes('already been registered')) {
        console.log('   ⚠️ Le compte client@test.com existe déjà, connexion...')
        const { data: existingClient, error: loginError } = await supabase.auth.signInWithPassword({
          email: 'client@test.com',
          password: 'test123456'
        })
        if (existingClient?.user) {
          clientId = existingClient.user.id
          console.log(`   ✅ Compte client trouvé (ID: ${clientId})`)
        } else if (loginError) {
          console.log('   ⚠️ Impossible de se connecter, création du profil manuel...')
        }
      } else {
        console.error('   ❌ Erreur:', clientAuthError.message)
      }
    } else if (clientAuth?.user) {
      clientId = clientAuth.user.id
      console.log(`   ✅ Compte client créé (ID: ${clientId})`)
    }

    if (clientId) {
      // Créer le profil client
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: clientId,
          role: 'client',
          display_name: 'Client Test'
        }, { onConflict: 'id' })

      if (profileError) {
        console.error('   ❌ Erreur création profil:', profileError.message)
      } else {
        console.log('   ✅ Profil client créé/mis à jour')
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
        }, { onConflict: 'id' })

      if (clientError) {
        console.error('   ❌ Erreur création données client:', clientError.message)
      } else {
        console.log('   ✅ Données client créées/mises à jour')
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

    let restoId = null

    if (restoAuthError) {
      if (restoAuthError.message.includes('already registered') || restoAuthError.message.includes('already been registered')) {
        console.log('   ⚠️ Le compte resto@test.com existe déjà, connexion...')
        const { data: existingResto, error: loginError } = await supabase.auth.signInWithPassword({
          email: 'resto@test.com',
          password: 'test123456'
        })
        if (existingResto?.user) {
          restoId = existingResto.user.id
          console.log(`   ✅ Compte restaurant trouvé (ID: ${restoId})`)
        } else if (loginError) {
          console.log('   ⚠️ Impossible de se connecter, création du profil manuel...')
        }
      } else {
        console.error('   ❌ Erreur:', restoAuthError.message)
      }
    } else if (restoAuth?.user) {
      restoId = restoAuth.user.id
      console.log(`   ✅ Compte restaurant créé (ID: ${restoId})`)
    }

    if (restoId) {
      // Créer le profil restaurant
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: restoId,
          role: 'restaurant',
          display_name: 'Restaurant Test'
        }, { onConflict: 'id' })

      if (profileError) {
        console.error('   ❌ Erreur création profil:', profileError.message)
      } else {
        console.log('   ✅ Profil restaurant créé/mis à jour')
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
        }, { onConflict: 'id' })

      if (restoError) {
        console.error('   ❌ Erreur création données restaurant:', restoError.message)
      } else {
        console.log('   ✅ Données restaurant créées/mises à jour')
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
        if (dealError.message.includes('duplicate') || dealError.message.includes('already exists')) {
          console.log('   ⚠️ Le deal existe déjà')
        } else {
          console.error('   ❌ Erreur création deal:', dealError.message)
        }
      } else {
        console.log('   ✅ Deal créé')
      }
    }

    console.log('\n✅ Données de test créées avec succès!')
    console.log('\n📋 Comptes créés:')
    console.log('   👤 Client: client@test.com / test123456')
    console.log('   🍕 Restaurant: resto@test.com / test123456')
    console.log('\n🔍 Vérifie dans Supabase → Table Editor pour voir les données!')

  } catch (error) {
    console.error('\n❌ Erreur:', error.message)
    console.error(error)
    process.exit(1)
  }
}

createTestData()

