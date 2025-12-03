import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database'

// Debug: vérifier ce que Vite charge
console.log('🔍 Debug env vars:', {
  VITE_SUPABASE_URL: import.meta.env.VITE_SUPABASE_URL,
  VITE_SUPABASE_ANON_KEY: import.meta.env.VITE_SUPABASE_ANON_KEY ? 'Present' : 'Missing',
  allEnv: import.meta.env
})

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Supabase credentials not found!')
  console.error('VITE_SUPABASE_URL:', supabaseUrl)
  console.error('VITE_SUPABASE_ANON_KEY:', supabaseAnonKey ? 'Present' : 'Missing')
  console.error('Please check your .env file contains:')
  console.error('VITE_SUPABASE_URL=...')
  console.error('VITE_SUPABASE_ANON_KEY=...')
  throw new Error('Supabase configuration is missing. Please check your .env file and restart the dev server.')
}

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey)

