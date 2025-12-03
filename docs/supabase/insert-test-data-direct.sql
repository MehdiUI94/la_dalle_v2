-- ============================================================================
-- INSÉRER DES DONNÉES DE TEST DIRECTEMENT DANS SUPABASE
-- ============================================================================
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Les données seront créées directement dans les tables
-- 
-- NOTE : Ce script crée les profils mais pas les utilisateurs auth.
-- Pour créer les utilisateurs auth, utilise l'app ou l'API Auth.
-- ============================================================================

-- ÉTAPE 1 : Créer des UUID pour les utilisateurs de test
-- (Tu peux aussi utiliser les IDs d'utilisateurs existants dans auth.users)

DO $$
DECLARE
  client_uuid UUID := gen_random_uuid();
  restaurant_uuid UUID := gen_random_uuid();
BEGIN

  -- Créer le profil CLIENT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (
    client_uuid,
    'client',
    'Client Test',
    now(),
    now()
  )
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  -- Créer les données CLIENT
  INSERT INTO public.clients (
    id, age, is_student, school_name, main_arrondissement,
    budget_range, favorite_categories, created_at, updated_at
  )
  VALUES (
    client_uuid,
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

  -- Créer le profil RESTAURANT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (
    restaurant_uuid,
    'restaurant',
    'Restaurant Test',
    now(),
    now()
  )
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  -- Créer les données RESTAURANT
  INSERT INTO public.restaurants (
    id, name, description, address, arrondissement, lat, lng,
    phone, instagram, price_level, cuisine_types,
    is_student_friendly, max_deals_per_day, created_at, updated_at
  )
  VALUES (
    restaurant_uuid,
    'Pizza Paradise Test',
    'Restaurant de test - Pizzas artisanales au feu de bois',
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

  -- Créer un DEAL pour le restaurant
  INSERT INTO public.deals (
    restaurant_id, title, description, deal_type, category,
    min_group_size, is_active, badge, created_at, updated_at
  )
  VALUES (
    restaurant_uuid,
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

  RAISE NOTICE '✅ Données de test créées!';
  RAISE NOTICE '   Client UUID: %', client_uuid;
  RAISE NOTICE '   Restaurant UUID: %', restaurant_uuid;

END $$;

-- Vérifier les données créées
SELECT 'Profiles créés:' as info;
SELECT * FROM public.profiles ORDER BY created_at DESC LIMIT 5;

SELECT 'Clients créés:' as info;
SELECT * FROM public.clients;

SELECT 'Restaurants créés:' as info;
SELECT * FROM public.restaurants;

SELECT 'Deals créés:' as info;
SELECT d.*, r.name as restaurant_name 
FROM public.deals d
LEFT JOIN public.restaurants r ON d.restaurant_id = r.id
ORDER BY d.created_at DESC;

