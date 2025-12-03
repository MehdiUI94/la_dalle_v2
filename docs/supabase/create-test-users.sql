-- ============================================================================
-- CRÉER DES UTILISATEURS DE TEST DIRECTEMENT DANS SUPABASE
-- ============================================================================
-- 
-- Ce script crée des utilisateurs de test que tu peux utiliser pour tester l'app
-- Exécute ce script dans SQL Editor de Supabase
--
-- ============================================================================

-- IMPORTANT : 
-- Pour créer des utilisateurs dans auth.users, tu dois utiliser l'API Supabase Auth
-- ou l'interface d'authentification. Ce script montre comment créer les profils
-- une fois que les utilisateurs existent.

-- ============================================================================
-- MÉTHODE 1 : Créer les utilisateurs via l'app (RECOMMANDÉ)
-- ============================================================================

-- 1. Va sur http://localhost:5173/login
-- 2. Crée un compte CLIENT :
--    - Email: client@test.com
--    - Password: test123456
--    - Sélectionne "Client"
--
-- 3. Crée un compte RESTAURANT :
--    - Email: resto@test.com  
--    - Password: test123456
--    - Sélectionne "Restaurant"
--
-- 4. Les profils seront automatiquement créés dans les tables profiles, clients, restaurants

-- ============================================================================
-- MÉTHODE 2 : Créer les profils manuellement (si les utilisateurs existent déjà)
-- ============================================================================

-- Étape 1 : Trouver les IDs des utilisateurs
-- Va dans Table Editor → auth.users et copie les IDs

-- Étape 2 : Créer le profil CLIENT (remplace UUID_CLIENT par l'ID réel)
/*
INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
VALUES (
  'UUID_CLIENT_ICI',  -- Remplace par l'ID de l'utilisateur client
  'client',
  'Client Test',
  now(),
  now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.clients (
  id,
  age,
  is_student,
  school_name,
  main_arrondissement,
  budget_range,
  favorite_categories,
  created_at,
  updated_at
)
VALUES (
  'UUID_CLIENT_ICI',  -- Même UUID que ci-dessus
  22,
  true,
  'Sorbonne',
  '11ème',
  '€€',
  ARRAY['pizza', 'burger', 'sushi'],
  now(),
  now()
)
ON CONFLICT (id) DO NOTHING;
*/

-- Étape 3 : Créer le profil RESTAURANT (remplace UUID_RESTAURANT par l'ID réel)
/*
INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
VALUES (
  'UUID_RESTAURANT_ICI',  -- Remplace par l'ID de l'utilisateur restaurant
  'restaurant',
  'Restaurant Test',
  now(),
  now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.restaurants (
  id,
  name,
  description,
  address,
  arrondissement,
  lat,
  lng,
  phone,
  instagram,
  price_level,
  cuisine_types,
  is_student_friendly,
  max_deals_per_day,
  created_at,
  updated_at
)
VALUES (
  'UUID_RESTAURANT_ICI',  -- Même UUID que ci-dessus
  'Pizza Paradise Test',
  'Restaurant de test pour développement - Pizzas artisanales au feu de bois',
  '123 rue de Test, 75011 Paris',
  '11ème',
  48.8566,
  2.3522,
  '01 23 45 67 89',
  '@pizzaparadiseparis',
  '€€',
  ARRAY['pizza', 'italian'],
  true,
  50,
  now(),
  now()
)
ON CONFLICT (id) DO NOTHING;
*/

-- Étape 4 : Créer un deal pour le restaurant
/*
INSERT INTO public.deals (
  restaurant_id,
  title,
  description,
  deal_type,
  category,
  min_group_size,
  is_active,
  badge,
  created_at,
  updated_at
)
VALUES (
  'UUID_RESTAURANT_ICI',  -- UUID du restaurant
  '1 Pizza = 1 Pizza offerte',
  'Deal de test - Pizza au choix',
  '1+1',
  'pizza',
  2,
  true,
  '🔥 Populaire',
  now(),
  now()
);
*/

-- ============================================================================
-- REQUÊTES UTILES POUR VÉRIFIER
-- ============================================================================

-- Voir tous les utilisateurs auth
-- SELECT id, email, created_at FROM auth.users;

-- Voir tous les profils
-- SELECT * FROM public.profiles;

-- Voir tous les clients avec leurs infos
-- SELECT p.*, c.* 
-- FROM public.profiles p
-- JOIN public.clients c ON p.id = c.id
-- WHERE p.role = 'client';

-- Voir tous les restaurants avec leurs infos
-- SELECT p.*, r.* 
-- FROM public.profiles p
-- JOIN public.restaurants r ON p.id = r.id
-- WHERE p.role = 'restaurant';

-- Voir tous les deals actifs
-- SELECT d.*, r.name as restaurant_name
-- FROM public.deals d
-- JOIN public.restaurants r ON d.restaurant_id = r.id
-- WHERE d.is_active = true;

