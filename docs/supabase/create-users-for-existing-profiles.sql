-- ============================================================================
-- CRÉER DES UTILISATEURS AUTH POUR LES PROFILS EXISTANTS
-- ============================================================================
-- 
-- Ce script crée des utilisateurs dans auth.users avec email et mot de passe
-- pour les profils qui existent déjà dans public.profiles
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Les utilisateurs seront créés avec les emails et mots de passe suivants :
--    - Client: client@test.com / test123456
--    - Restaurant: resto@test.com / test123456
-- ============================================================================

DO $$
DECLARE
  profile_record RECORD;
  user_email TEXT;
  user_password TEXT := 'test123456';
  user_role TEXT;
BEGIN

  -- Parcourir tous les profils existants
  FOR profile_record IN 
    SELECT id, role, display_name 
    FROM public.profiles
    WHERE id NOT IN (SELECT id FROM auth.users)
  LOOP
    
    -- Déterminer l'email selon le rôle
    IF profile_record.role = 'client' THEN
      user_email := 'client@test.com';
      user_role := 'client';
    ELSIF profile_record.role = 'restaurant' THEN
      user_email := 'resto@test.com';
      user_role := 'restaurant';
    ELSE
      user_email := 'user' || substring(profile_record.id::text, 1, 8) || '@test.com';
      user_role := profile_record.role;
    END IF;

    -- Vérifier si l'email existe déjà dans auth.users
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = user_email) THEN
      
      -- Créer l'utilisateur dans auth.users
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
        profile_record.id,  -- Utiliser le même ID que le profil
        '00000000-0000-0000-0000-000000000000',
        user_email,
        crypt(user_password, gen_salt('bf')),  -- Hash du mot de passe
        now(),  -- Email confirmé automatiquement
        COALESCE((SELECT created_at FROM public.profiles WHERE id = profile_record.id), now()),
        now(),
        '{"provider":"email","providers":["email"]}',
        jsonb_build_object('role', user_role, 'display_name', profile_record.display_name),
        false,
        'authenticated',
        'authenticated'
      );

      RAISE NOTICE '✅ Utilisateur créé: % (ID: %)', user_email, profile_record.id;
      
    ELSE
      RAISE NOTICE '⚠️ Email déjà utilisé: %', user_email;
    END IF;

  END LOOP;

  RAISE NOTICE '';
  RAISE NOTICE '✅ Tous les utilisateurs ont été créés!';
  RAISE NOTICE '';
  RAISE NOTICE '📋 Comptes créés:';
  RAISE NOTICE '   👤 Client: client@test.com / test123456';
  RAISE NOTICE '   🍕 Restaurant: resto@test.com / test123456';

END $$;

-- Vérifier les utilisateurs créés
SELECT 'Utilisateurs créés dans auth.users:' as info;
SELECT 
  u.id,
  u.email,
  u.email_confirmed_at,
  u.created_at,
  p.role,
  p.display_name
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
ORDER BY u.created_at DESC;

-- Vérifier que tous les profils ont maintenant un utilisateur correspondant
SELECT 'Profils sans utilisateur (devrait être vide):' as info;
SELECT p.id, p.role, p.display_name
FROM public.profiles p
WHERE p.id NOT IN (SELECT id FROM auth.users);

