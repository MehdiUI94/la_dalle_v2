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
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function insertTestData() {
  console.log('🚀 Insertion des données de test via API Supabase...\n')

  try {
    // Générer des UUID pour les profils
    const clientUuid = crypto.randomUUID()
    const restaurantUuid = crypto.randomUUID()

    console.log('1️⃣ Création du profil CLIENT...')
    
    // Créer le profil client
    const { error: profileError1 } = await supabase
      .from('profiles')
      .insert({
        id: clientUuid,
        role: 'client',
        display_name: 'Client Test'
      })

    if (profileError1) {
      console.error('   ❌ Erreur:', profileError1.message)
    } else {
      console.log(`   ✅ Profil client créé (ID: ${clientUuid})`)
    }

    // Créer les données client
    const { error: clientError } = await supabase
      .from('clients')
      .insert({
        id: clientUuid,
        age: 22,
        is_student: true,
        school_name: 'Sorbonne',
        main_arrondissement: '11ème',
        budget_range: '€€',
        favorite_categories: ['pizza', 'burger', 'sushi']
      })

    if (clientError) {
      console.error('   ❌ Erreur données client:', clientError.message)
    } else {
      console.log('   ✅ Données client créées')
    }

    console.log('')

    console.log('2️⃣ Création du profil RESTAURANT...')
    
    // Créer le profil restaurant
    const { error: profileError2 } = await supabase
      .from('profiles')
      .insert({
        id: restaurantUuid,
        role: 'restaurant',
        display_name: 'Restaurant Test'
      })

    if (profileError2) {
      console.error('   ❌ Erreur:', profileError2.message)
    } else {
      console.log(`   ✅ Profil restaurant créé (ID: ${restaurantUuid})`)
    }

    // Créer les données restaurant
    const { error: restoError } = await supabase
      .from('restaurants')
      .insert({
        id: restaurantUuid,
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

    if (restoError) {
      console.error('   ❌ Erreur données restaurant:', restoError.message)
    } else {
      console.log('   ✅ Données restaurant créées')
    }

    // Créer un deal
    const { error: dealError } = await supabase
      .from('deals')
      .insert({
        restaurant_id: restaurantUuid,
        title: '1 Pizza = 1 Pizza offerte',
        description: 'Deal de test - Pizza au choix',
        deal_type: '1+1',
        category: 'pizza',
        min_group_size: 2,
        is_active: true,
        badge: '🔥 Populaire'
      })

    if (dealError) {
      console.error('   ❌ Erreur création deal:', dealError.message)
    } else {
      console.log('   ✅ Deal créé')
    }

    console.log('\n✅ Données de test insérées!')
    console.log('\n🔍 Vérifie dans Supabase → Table Editor:')
    console.log('   - Table "profiles" → Tu devrais voir 2 profils')
    console.log('   - Table "clients" → Tu devrais voir 1 client')
    console.log('   - Table "restaurants" → Tu devrais voir 1 restaurant')
    console.log('   - Table "deals" → Tu devrais voir 1 deal')

  } catch (error) {
    console.error('\n❌ Erreur:', error.message)
    console.error(error)
    process.exit(1)
  }
}

insertTestData()

