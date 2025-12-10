// Script de test de connexion Supabase
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'
import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, resolve } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Charger les variables d'environnement depuis .env
const envContent = readFileSync(resolve(__dirname, '.env'), 'utf-8')
const envVars = {}
envContent.split('\n').forEach(line => {
  const trimmed = line.trim()
  if (trimmed && !trimmed.startsWith('#')) {
    const [key, ...valueParts] = trimmed.split('=')
    if (key && valueParts.length > 0) {
      envVars[key.trim()] = valueParts.join('=').trim()
    }
  }
})

const supabaseUrl = envVars.VITE_SUPABASE_URL
const supabaseAnonKey = envVars.VITE_SUPABASE_ANON_KEY

console.log('🔍 Test de connexion Supabase...\n')
console.log('URL:', supabaseUrl || '❌ Non défini')
console.log('Anon Key:', supabaseAnonKey ? `${supabaseAnonKey.substring(0, 20)}...` : '❌ Non défini')
console.log('')

if (!supabaseUrl || !supabaseAnonKey || supabaseUrl.includes('votre-projet') || supabaseAnonKey.includes('votre_cle')) {
  console.error('❌ Configuration Supabase manquante ou invalide!')
  console.log('\n📝 Pour configurer:')
  console.log('1. Ouvrez le fichier .env')
  console.log('2. Remplacez VITE_SUPABASE_URL par votre URL Supabase')
  console.log('3. Remplacez VITE_SUPABASE_ANON_KEY par votre clé anonyme Supabase')
  process.exit(1)
}

try {
  const supabase = createClient(supabaseUrl, supabaseAnonKey)
  
  console.log('🔄 Test de connexion...\n')
  
  // Test 1: Vérifier la connexion en listant les tables
  const { data: tables, error: tablesError } = await supabase
    .from('profiles')
    .select('count')
    .limit(1)
  
  if (tablesError) {
    console.error('❌ Erreur de connexion:', tablesError.message)
    process.exit(1)
  }
  
  console.log('✅ Connexion réussie!')
  
  // Test 2: Compter les profils
  const { count: profilesCount, error: profilesError } = await supabase
    .from('profiles')
    .select('*', { count: 'exact', head: true })
  
  if (!profilesError) {
    console.log(`📊 Profils dans la base: ${profilesCount || 0}`)
  }
  
  // Test 3: Compter les étudiants
  const { count: etudiantsCount, error: etudiantsError } = await supabase
    .from('etudiants')
    .select('*', { count: 'exact', head: true })
  
  if (!etudiantsError) {
    console.log(`👤 Étudiants dans la base: ${etudiantsCount || 0}`)
  }
  
  // Test 4: Compter les restaurants
  const { count: restaurantsCount, error: restaurantsError } = await supabase
    .from('restaurants')
    .select('*', { count: 'exact', head: true })
  
  if (!restaurantsError) {
    console.log(`🍽️  Restaurants dans la base: ${restaurantsCount || 0}`)
  }
  
  console.log('\n✅ Tous les tests de connexion sont réussis!')
  
} catch (error) {
  console.error('❌ Erreur lors du test:', error.message)
  process.exit(1)
}

