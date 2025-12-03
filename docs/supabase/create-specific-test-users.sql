-- ============================================================================
-- CRÉER DES UTILISATEURS AUTH POUR LES DONNÉES DE TEST
-- ============================================================================
-- 
-- Ce script crée des utilisateurs auth.users avec email et mot de passe
-- pour les profils de test (client et restaurant)
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Les utilisateurs seront créés avec :
--    - Client: client@test.com / test123456
--    - Restaurant: resto@test.com / test123456
-- ============================================================================

DO $$
DECLARE
  client_uuid UUID;
  restaurant_uuid UUID;
  client_email TEXT := 'client@test.com';
  restaurant_email TEXT := 'resto@test.com';
  test_password TEXT := 'test123456';
BEGIN

  -- Trouver ou créer l'UUID pour le client
  SELECT id INTO client_uuid 
  FROM public.profiles 
  WHERE role = 'client' 
  LIMIT 1;

  -- Si aucun profil client n'existe, créer un UUID
  IF client_uuid IS NULL THEN
    client_uuid := gen_random_uuid();
    RAISE NOTICE '⚠️ Aucun profil client trouvé, création d''un nouveau UUID: %', client_uuid;
  END IF;

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
    role,
    aud
  )
  VALUES (
    client_uuid,
    '00000000-0000-0000-0000-000000000000',
    client_email,
    crypt(test_password, gen_salt('bf')),
    now(),
    COALESCE((SELECT created_at FROM public.profiles WHERE id = client_uuid), now()),
    now(),
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object('role', 'client'),
    false,
    'authenticated',
    'authenticated'
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    encrypted_password = EXCLUDED.encrypted_password,
    email_confirmed_at = now(),
    updated_at = now();

  RAISE NOTICE '✅ Utilisateur CLIENT créé: % (ID: %)', client_email, client_uuid;

  -- Trouver ou créer l'UUID pour le restaurant
  SELECT id INTO restaurant_uuid 
  FROM public.profiles 
  WHERE role = 'restaurant' 
  LIMIT 1;

  -- Si aucun profil restaurant n'existe, créer un UUID
  IF restaurant_uuid IS NULL THEN
    restaurant_uuid := gen_random_uuid();
    RAISE NOTICE '⚠️ Aucun profil restaurant trouvé, création d''un nouveau UUID: %', restaurant_uuid;
  END IF;

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
    role,
    aud
  )
  VALUES (
    restaurant_uuid,
    '00000000-0000-0000-0000-000000000000',
    restaurant_email,
    crypt(test_password, gen_salt('bf')),
    now(),
    COALESCE((SELECT created_at FROM public.profiles WHERE id = restaurant_uuid), now()),
    now(),
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object('role', 'restaurant'),
    false,
    'authenticated',
    'authenticated'
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    encrypted_password = EXCLUDED.encrypted_password,
    email_confirmed_at = now(),
    updated_at = now();

  RAISE NOTICE '✅ Utilisateur RESTAURANT créé: % (ID: %)', restaurant_email, restaurant_uuid;

  -- S'assurer que les profils existent avec les bons IDs
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (client_uuid, 'client', 'Client Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (restaurant_uuid, 'restaurant', 'Restaurant Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  RAISE NOTICE '';
  RAISE NOTICE '✅ Utilisateurs créés avec succès!';
  RAISE NOTICE '';
  RAISE NOTICE '📋 Comptes de connexion:';
  RAISE NOTICE '   👤 Client: % / %', client_email, test_password;
  RAISE NOTICE '   🍕 Restaurant: % / %', restaurant_email, test_password;

END $$;

-- Vérifier les utilisateurs créés
SELECT 'Utilisateurs dans auth.users:' as info;
SELECT 
  id,
  email,
  email_confirmed_at IS NOT NULL as email_confirmed,
  created_at
FROM auth.users
WHERE email IN ('client@test.com', 'resto@test.com')
ORDER BY created_at DESC;

-- Vérifier la correspondance avec les profils
SELECT 'Correspondance profils/utilisateurs:' as info;
SELECT 
  p.id,
  p.role,
  p.display_name,
  u.email,
  u.email_confirmed_at IS NOT NULL as can_login
FROM public.profiles p
LEFT JOIN auth.users u ON p.id = u.id
WHERE p.role IN ('client', 'restaurant')
ORDER BY p.role, p.created_at;

