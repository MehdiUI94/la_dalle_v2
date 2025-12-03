-- ============================================================================
-- AJOUTER EMAIL ET MOT DE PASSE AUX TABLES CLIENTS ET RESTAURANTS
-- ============================================================================
-- 
-- Ce script :
-- 1. Ajoute les colonnes email et password aux tables clients et restaurants
-- 2. Remplit ces champs avec des données de test pour les lignes existantes
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Les colonnes seront ajoutées et remplies automatiquement
-- ============================================================================

-- ============================================================================
-- 1. MODIFIER LA TABLE CLIENTS
-- ============================================================================

-- Ajouter la colonne email si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'email'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN email TEXT;
    RAISE NOTICE '✅ Colonne email ajoutée à la table clients';
  ELSE
    RAISE NOTICE '⚠️ Colonne email existe déjà dans clients';
  END IF;
END $$;

-- Ajouter la colonne password si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'password'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN password TEXT;
    RAISE NOTICE '✅ Colonne password ajoutée à la table clients';
  ELSE
    RAISE NOTICE '⚠️ Colonne password existe déjà dans clients';
  END IF;
END $$;

-- Remplir les emails et mots de passe pour les clients existants
DO $$
BEGIN
  UPDATE public.clients
  SET 
    email = COALESCE(
      email,
      'client' || substring(id::text, 1, 8) || '@test.com'
    ),
    password = COALESCE(
      password,
      'test123456'
    )
  WHERE email IS NULL OR password IS NULL;
  
  RAISE NOTICE '✅ Données de test ajoutées aux clients existants';
END $$;

-- ============================================================================
-- 2. MODIFIER LA TABLE RESTAURANTS
-- ============================================================================

-- Ajouter la colonne email si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'email'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN email TEXT;
    RAISE NOTICE '✅ Colonne email ajoutée à la table restaurants';
  ELSE
    RAISE NOTICE '⚠️ Colonne email existe déjà dans restaurants';
  END IF;
END $$;

-- Ajouter la colonne password si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'password'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN password TEXT;
    RAISE NOTICE '✅ Colonne password ajoutée à la table restaurants';
  ELSE
    RAISE NOTICE '⚠️ Colonne password existe déjà dans restaurants';
  END IF;
END $$;

-- Remplir les emails et mots de passe pour les restaurants existants
DO $$
BEGIN
  UPDATE public.restaurants
  SET 
    email = COALESCE(
      email,
      CASE 
        WHEN name ILIKE '%pizza%' THEN 'pizza@test.com'
        WHEN name ILIKE '%burger%' THEN 'burger@test.com'
        WHEN name ILIKE '%sushi%' THEN 'sushi@test.com'
        ELSE 'resto' || substring(id::text, 1, 8) || '@test.com'
      END
    ),
    password = COALESCE(
      password,
      'test123456'
    )
  WHERE email IS NULL OR password IS NULL;
  
  RAISE NOTICE '✅ Données de test ajoutées aux restaurants existants';
END $$;

-- ============================================================================
-- 3. VÉRIFICATION
-- ============================================================================

-- Vérifier les clients avec leurs emails et mots de passe
SELECT 'Clients avec email/password:' as info;
SELECT 
  id,
  email,
  password,
  age,
  is_student,
  main_arrondissement
FROM public.clients
ORDER BY created_at DESC;

-- Vérifier les restaurants avec leurs emails et mots de passe
SELECT 'Restaurants avec email/password:' as info;
SELECT 
  id,
  name,
  email,
  password,
  arrondissement,
  phone
FROM public.restaurants
ORDER BY created_at DESC;

-- Compter les lignes mises à jour
SELECT 
  'Résumé:' as info,
  (SELECT COUNT(*) FROM public.clients WHERE email IS NOT NULL) as clients_avec_email,
  (SELECT COUNT(*) FROM public.restaurants WHERE email IS NOT NULL) as restaurants_avec_email;

