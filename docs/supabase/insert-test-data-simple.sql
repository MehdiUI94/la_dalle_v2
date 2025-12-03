-- ============================================================================
-- SOLUTION SIMPLE : Utiliser des utilisateurs existants
-- ============================================================================
-- 
-- Si tu as déjà créé des comptes via l'app (/login), utilise ce script
-- qui récupère leurs IDs et crée les profils
-- ============================================================================

DO $$
DECLARE
  client_uuid UUID;
  restaurant_uuid UUID;
BEGIN

  -- Récupérer l'ID du client (si existe)
  SELECT id INTO client_uuid 
  FROM auth.users 
  WHERE email = 'client@test.com' 
  LIMIT 1;

  -- Si le client n'existe pas, créer un utilisateur
  IF client_uuid IS NULL THEN
    client_uuid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data, role
    )
    VALUES (
      client_uuid,
      '00000000-0000-0000-0000-000000000000',
      'client@test.com',
      crypt('test123456', gen_salt('bf')),
      now(),
      now(),
      now(),
      '{"provider":"email"}',
      '{}',
      'authenticated'
    );
  END IF;

  -- Créer le profil CLIENT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (client_uuid, 'client', 'Client Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  INSERT INTO public.clients (
    id, age, is_student, school_name, main_arrondissement,
    budget_range, favorite_categories, created_at, updated_at
  )
  VALUES (
    client_uuid, 22, true, 'Sorbonne', '11ème',
    '€€', ARRAY['pizza', 'burger', 'sushi'], now(), now()
  )
  ON CONFLICT (id) DO NOTHING;

  -- Récupérer l'ID du restaurant (si existe)
  SELECT id INTO restaurant_uuid 
  FROM auth.users 
  WHERE email = 'resto@test.com' 
  LIMIT 1;

  -- Si le restaurant n'existe pas, créer un utilisateur
  IF restaurant_uuid IS NULL THEN
    restaurant_uuid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data, role
    )
    VALUES (
      restaurant_uuid,
      '00000000-0000-0000-0000-000000000000',
      'resto@test.com',
      crypt('test123456', gen_salt('bf')),
      now(),
      now(),
      now(),
      '{"provider":"email"}',
      '{}',
      'authenticated'
    );
  END IF;

  -- Créer le profil RESTAURANT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (restaurant_uuid, 'restaurant', 'Restaurant Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

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
    '11ème', 48.8566, 2.3522,
    '01 23 45 67 89', '@pizzaparadiseparis', '€€',
    ARRAY['pizza', 'italian'], true, 50, now(), now()
  )
  ON CONFLICT (id) DO NOTHING;

  -- Créer un DEAL
  INSERT INTO public.deals (
    restaurant_id, title, description, deal_type, category,
    min_group_size, is_active, badge, created_at, updated_at
  )
  VALUES (
    restaurant_uuid,
    '1 Pizza = 1 Pizza offerte',
    'Deal de test - Pizza au choix',
    '1+1', 'pizza', 2, true, '🔥 Populaire', now(), now()
  );

  RAISE NOTICE '✅ Données créées!';
  RAISE NOTICE '   Client: %', client_uuid;
  RAISE NOTICE '   Restaurant: %', restaurant_uuid;

END $$;

-- Vérification
SELECT 'Utilisateurs:' as info;
SELECT id, email FROM auth.users WHERE email IN ('client@test.com', 'resto@test.com');

SELECT 'Profiles:' as info;
SELECT * FROM public.profiles;

SELECT 'Clients:' as info;
SELECT * FROM public.clients;

SELECT 'Restaurants:' as info;
SELECT * FROM public.restaurants;

SELECT 'Deals:' as info;
SELECT d.*, r.name FROM public.deals d LEFT JOIN public.restaurants r ON d.restaurant_id = r.id;

