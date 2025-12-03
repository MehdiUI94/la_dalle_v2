-- ============================================================================
-- INSÉRER DES DONNÉES DE TEST DANS SUPABASE
-- ============================================================================
-- 
-- INSTRUCTIONS :
-- 1. Crée d'abord les comptes via l'app (/login → S'inscrire)
--    - client@test.com / test123456 (Client)
--    - resto@test.com / test123456 (Restaurant)
--
-- 2. Va dans Supabase → Table Editor → auth.users
--    - Trouve les IDs (UUID) des utilisateurs créés
--
-- 3. Remplace UUID_CLIENT et UUID_RESTAURANT ci-dessous par les vrais IDs
--
-- 4. Exécute ce script dans SQL Editor
--
-- ============================================================================

-- ÉTAPE 1 : Trouver les IDs des utilisateurs
-- Exécute cette requête pour voir tous les utilisateurs :
SELECT id, email, created_at FROM auth.users ORDER BY created_at DESC;

-- ÉTAPE 2 : Copier les IDs et les remplacer dans les scripts ci-dessous

-- ============================================================================
-- CRÉER LE PROFIL CLIENT (remplace UUID_CLIENT par l'ID réel)
-- ============================================================================

-- Exemple avec un UUID fictif - REMPLACE par le vrai ID
-- INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
-- VALUES (
--   'UUID_CLIENT_ICI',  -- ⚠️ REMPLACE par l'ID de l'utilisateur client
--   'client',
--   'Client Test',
--   now(),
--   now()
-- )
-- ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

-- INSERT INTO public.clients (
--   id, age, is_student, school_name, main_arrondissement, 
--   budget_range, favorite_categories, created_at, updated_at
-- )
-- VALUES (
--   'UUID_CLIENT_ICI',  -- ⚠️ Même UUID que ci-dessus
--   22,
--   true,
--   'Sorbonne',
--   '11ème',
--   '€€',
--   ARRAY['pizza', 'burger', 'sushi'],
--   now(),
--   now()
-- )
-- ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- CRÉER LE PROFIL RESTAURANT (remplace UUID_RESTAURANT par l'ID réel)
-- ============================================================================

-- INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
-- VALUES (
--   'UUID_RESTAURANT_ICI',  -- ⚠️ REMPLACE par l'ID de l'utilisateur restaurant
--   'restaurant',
--   'Restaurant Test',
--   now(),
--   now()
-- )
-- ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

-- INSERT INTO public.restaurants (
--   id, name, description, address, arrondissement, lat, lng,
--   phone, instagram, price_level, cuisine_types, 
--   is_student_friendly, max_deals_per_day, created_at, updated_at
-- )
-- VALUES (
--   'UUID_RESTAURANT_ICI',  -- ⚠️ Même UUID que ci-dessus
--   'Pizza Paradise Test',
--   'Restaurant de test - Pizzas artisanales au feu de bois',
--   '123 rue de Test, 75011 Paris',
--   '11ème',
--   48.8566,
--   2.3522,
--   '01 23 45 67 89',
--   '@pizzaparadiseparis',
--   '€€',
--   ARRAY['pizza', 'italian'],
--   true,
--   50,
--   now(),
--   now()
-- )
-- ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- CRÉER UN DEAL POUR LE RESTAURANT
-- ============================================================================

-- INSERT INTO public.deals (
--   restaurant_id, title, description, deal_type, category,
--   min_group_size, is_active, badge, created_at, updated_at
-- )
-- VALUES (
--   'UUID_RESTAURANT_ICI',  -- ⚠️ UUID du restaurant
--   '1 Pizza = 1 Pizza offerte',
--   'Deal de test - Pizza au choix',
--   '1+1',
--   'pizza',
--   2,
--   true,
--   '🔥 Populaire',
--   now(),
--   now()
-- );

-- ============================================================================
-- VÉRIFICATIONS
-- ============================================================================

-- Voir tous les profils
-- SELECT * FROM public.profiles ORDER BY created_at DESC;

-- Voir tous les clients
-- SELECT * FROM public.clients;

-- Voir tous les restaurants
-- SELECT * FROM public.restaurants;

-- Voir tous les deals
-- SELECT d.*, r.name as restaurant_name 
-- FROM public.deals d
-- LEFT JOIN public.restaurants r ON d.restaurant_id = r.id
-- ORDER BY d.created_at DESC;

