import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

const sqlFile = join(__dirname, '..', 'docs', 'supabase', 'insert-test-data-direct.sql')
const sql = readFileSync(sqlFile, 'utf-8')

console.log('\n' + '='.repeat(80))
console.log('📋 SCRIPT SQL POUR AJOUTER LES DONNÉES DE TEST')
console.log('='.repeat(80))
console.log('\nCopie-colle ce script dans Supabase SQL Editor et exécute-le :\n')
console.log(sql)
console.log('\n' + '='.repeat(80))
console.log('\n✅ Instructions :')
console.log('1. Va sur https://app.supabase.com')
console.log('2. Sélectionne ton projet la_dalle')
console.log('3. Va dans SQL Editor (menu gauche)')
console.log('4. Clique sur "New query"')
console.log('5. Copie-colle le script ci-dessus')
console.log('6. Clique sur "Run" (▶️) ou Ctrl+Enter')
console.log('7. Vérifie dans Table Editor que les données sont créées!\n')

