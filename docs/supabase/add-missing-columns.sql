-- Script pour ajouter les colonnes manquantes dans les tables clients et restaurants
-- Si vous obtenez l'erreur "Could not find the 'address' column", exécutez ce script

-- ============================================
-- TABLE CLIENTS
-- ============================================

-- Ajouter la colonne address si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'address'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN address TEXT;
    RAISE NOTICE 'Colonne address ajoutée à la table clients';
  ELSE
    RAISE NOTICE 'Colonne address existe déjà dans la table clients';
  END IF;
END $$;

-- Vérifier et ajouter les autres colonnes si nécessaire
DO $$
BEGIN
  -- firstname
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'firstname'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN firstname TEXT;
  END IF;

  -- lastname
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'lastname'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN lastname TEXT;
  END IF;

  -- age
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'age'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN age INTEGER;
  END IF;

  -- phone
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'phone'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN phone TEXT;
  END IF;

  -- ine
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'ine'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN ine TEXT UNIQUE;
  END IF;

  -- is_student
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'is_student'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN is_student BOOLEAN DEFAULT TRUE NOT NULL;
  END IF;

  -- notifications_email
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'notifications_email'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN notifications_email BOOLEAN DEFAULT FALSE;
  END IF;

  -- notifications_phone
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'notifications_phone'
  ) THEN
    ALTER TABLE public.clients ADD COLUMN notifications_phone BOOLEAN DEFAULT FALSE;
  END IF;

  RAISE NOTICE 'Vérification des colonnes clients terminée';
END $$;

-- ============================================
-- TABLE RESTAURANTS
-- ============================================

-- Ajouter la colonne address si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'address'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN address TEXT;
    RAISE NOTICE 'Colonne address ajoutée à la table restaurants';
  ELSE
    RAISE NOTICE 'Colonne address existe déjà dans la table restaurants';
  END IF;
END $$;

-- Vérifier et ajouter les autres colonnes si nécessaire
DO $$
BEGIN
  -- owner_firstname
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'owner_firstname'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN owner_firstname TEXT;
  END IF;

  -- owner_lastname
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'owner_lastname'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN owner_lastname TEXT;
  END IF;

  -- description
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'description'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN description TEXT;
  END IF;

  -- logo
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'logo'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN logo TEXT;
  END IF;

  -- siren
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'siren'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN siren TEXT;
  END IF;

  -- siret
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'siret'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN siret TEXT;
  END IF;

  -- social_media
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'social_media'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN social_media TEXT;
  END IF;

  -- phone
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'phone'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN phone TEXT;
  END IF;

  -- notifications_email
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'notifications_email'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN notifications_email BOOLEAN DEFAULT FALSE;
  END IF;

  -- notifications_phone
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'notifications_phone'
  ) THEN
    ALTER TABLE public.restaurants ADD COLUMN notifications_phone BOOLEAN DEFAULT FALSE;
  END IF;

  RAISE NOTICE 'Vérification des colonnes restaurants terminée';
END $$;

-- Vérifier les colonnes créées
SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('clients', 'restaurants')
ORDER BY table_name, ordinal_position;

