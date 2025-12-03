-- ============================================================================
-- INSÉRER DES DONNÉES DE TEST AVEC UTILISATEURS AUTH
-- ============================================================================
-- 
-- Ce script crée les utilisateurs dans auth.users puis leurs profils
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Les utilisateurs et leurs profils seront créés
-- ============================================================================

DO $$
DECLARE
  client_uuid UUID;
  restaurant_uuid UUID;
  client_email TEXT := 'client@test.com';
  restaurant_email TEXT := 'resto@test.com';
  -- Mot de passe hashé pour 'test123456' (bcrypt)
  password_hash TEXT := '$2a$10$rOzJqJqJqJqJqJqJqJqJqOqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJq';
BEGIN

  -- Générer des UUID pour les utilisateurs
  client_uuid := gen_random_uuid();
  restaurant_uuid := gen_random_uuid();

  -- Créer l'utilisateur CLIENT dans auth.users
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role
  )
  VALUES (
    client_uuid,
    '00000000-0000-0000-0000-000000000000',
    client_email,
    crypt('test123456', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"role":"client"}',
    false,
    'authenticated'
  )
  ON CONFLICT (email) DO NOTHING
  RETURNING id INTO client_uuid;

  -- Si l'utilisateur existe déjà, récupérer son ID
  IF client_uuid IS NULL THEN
    SELECT id INTO client_uuid FROM auth.users WHERE email = client_email;
  END IF;

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

  -- Créer l'utilisateur RESTAURANT dans auth.users
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role
  )
  VALUES (
    restaurant_uuid,
    '00000000-0000-0000-0000-000000000000',
    restaurant_email,
    crypt('test123456', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"role":"restaurant"}',
    false,
    'authenticated'
  )
  ON CONFLICT (email) DO NOTHING
  RETURNING id INTO restaurant_uuid;

  -- Si l'utilisateur existe déjà, récupérer son ID
  IF restaurant_uuid IS NULL THEN
    SELECT id INTO restaurant_uuid FROM auth.users WHERE email = restaurant_email;
  END IF;

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
  RAISE NOTICE '';
  RAISE NOTICE '📋 Comptes créés:';
  RAISE NOTICE '   👤 Client: client@test.com / test123456';
  RAISE NOTICE '   🍕 Restaurant: resto@test.com / test123456';

END $$;

-- Vérifier les données créées
SELECT 'Utilisateurs créés:' as info;
SELECT id, email, created_at FROM auth.users WHERE email IN ('client@test.com', 'resto@test.com');

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

