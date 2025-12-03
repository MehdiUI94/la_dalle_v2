-- ============================================================================
-- DONNÉES DE TEST - LA DALLE
-- Script pour créer un client test et un restaurant test dans Supabase
-- ============================================================================

-- IMPORTANT : 
-- 1. Ce script crée des utilisateurs dans auth.users (authentification)
-- 2. Puis crée leurs profils dans les tables correspondantes
-- 3. Exécute ce script dans SQL Editor de Supabase

-- ============================================================================
-- 1. CLIENT TEST
-- ============================================================================

-- Créer l'utilisateur client dans auth.users
-- Note: En production, utilisez l'API Supabase Auth pour créer les utilisateurs
-- Ici on utilise une fonction SQL pour créer un utilisateur de test

-- Pour créer un utilisateur client de test, utilise plutôt l'interface Auth ou l'API
-- Mais on peut créer directement le profil si l'utilisateur existe déjà

-- Si tu veux créer un utilisateur via SQL (nécessite des permissions admin) :
-- INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
-- VALUES (
--   gen_random_uuid(),
--   'client@test.com',
--   crypt('test123456', gen_salt('bf')),
--   now(),
--   now(),
--   now()
-- );

-- Pour l'instant, créons juste les profils de test avec des UUID fictifs
-- Tu devras créer les utilisateurs via l'interface Auth ou via l'app

-- ============================================================================
-- 2. CRÉER LES PROFILS DE TEST (après avoir créé les utilisateurs via l'app)
-- ============================================================================

-- Note: Remplace les UUID ci-dessous par les vrais IDs des utilisateurs créés via l'app
-- Tu peux trouver les IDs dans Table Editor → auth.users après avoir créé les comptes

-- Exemple de profil CLIENT TEST (remplace l'UUID par celui de ton utilisateur client)
-- INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
-- VALUES (
--   'UUID_DU_CLIENT_ICI',  -- Remplace par l'ID réel de l'utilisateur client
--   'client',
--   'Client Test',
--   now(),
--   now()
-- );

-- INSERT INTO public.clients (
--   id,
--   age,
--   is_student,
--   school_name,
--   main_arrondissement,
--   budget_range,
--   favorite_categories,
--   created_at,
--   updated_at
-- )
-- VALUES (
--   'UUID_DU_CLIENT_ICI',  -- Même UUID que dans profiles
--   22,
--   true,
--   'Sorbonne',
--   '11ème',
--   '€€',
--   ARRAY['pizza', 'burger', 'sushi'],
--   now(),
--   now()
-- );

-- ============================================================================
-- 3. RESTAURANT TEST
-- ============================================================================

-- Exemple de profil RESTAURANT TEST (remplace l'UUID par celui de ton utilisateur restaurant)
-- INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
-- VALUES (
--   'UUID_DU_RESTAURANT_ICI',  -- Remplace par l'ID réel de l'utilisateur restaurant
--   'restaurant',
--   'Restaurant Test',
--   now(),
--   now()
-- );

-- INSERT INTO public.restaurants (
--   id,
--   name,
--   description,
--   address,
--   arrondissement,
--   lat,
--   lng,
--   phone,
--   instagram,
--   price_level,
--   cuisine_types,
--   is_student_friendly,
--   max_deals_per_day,
--   created_at,
--   updated_at
-- )
-- VALUES (
--   'UUID_DU_RESTAURANT_ICI',  -- Même UUID que dans profiles
--   'Pizza Paradise Test',
--   'Restaurant de test pour développement - Pizzas artisanales au feu de bois',
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
-- );

-- ============================================================================
-- 4. CRÉER UN DEAL TEST (pour le restaurant)
-- ============================================================================

-- INSERT INTO public.deals (
--   restaurant_id,
--   title,
--   description,
--   deal_type,
--   category,
--   min_group_size,
--   is_active,
--   badge,
--   created_at,
--   updated_at
-- )
-- VALUES (
--   'UUID_DU_RESTAURANT_ICI',  -- UUID du restaurant
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
-- INSTRUCTIONS D'UTILISATION
-- ============================================================================

-- Méthode recommandée :
-- 1. Crée les comptes via l'app (/login → S'inscrire)
--    - Client : client@test.com / test123456
--    - Restaurant : resto@test.com / test123456
--
-- 2. Va dans Supabase → Table Editor → auth.users
--    - Trouve les IDs des utilisateurs créés
--
-- 3. Remplace les UUID dans ce script par les vrais IDs
--
-- 4. Exécute les INSERT dans SQL Editor

-- ============================================================================
-- VÉRIFICATION RAPIDE
-- ============================================================================

-- Pour voir tous les profils :
-- SELECT * FROM public.profiles;

-- Pour voir tous les clients :
-- SELECT * FROM public.clients;

-- Pour voir tous les restaurants :
-- SELECT * FROM public.restaurants;

-- Pour voir tous les deals :
-- SELECT * FROM public.deals;

