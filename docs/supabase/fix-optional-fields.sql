-- Script pour s'assurer que les champs optionnels sont vraiment optionnels (NULL autorisé)
-- À exécuter dans l'éditeur SQL de Supabase
-- Ce script supprime les contraintes NOT NULL des champs optionnels si elles existent

-- ============================================
-- TABLE CLIENTS - Champs optionnels
-- ============================================

-- S'assurer que phone peut être NULL (optionnel)
-- Si la colonne a une contrainte NOT NULL, on doit d'abord la supprimer
DO $$
BEGIN
  -- Vérifier si la colonne phone existe et a une contrainte NOT NULL
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'clients' 
    AND column_name = 'phone'
    AND is_nullable = 'NO'
  ) THEN
    -- Supprimer la contrainte NOT NULL
    ALTER TABLE public.clients ALTER COLUMN phone DROP NOT NULL;
  END IF;
END $$;

-- ============================================
-- TABLE RESTAURANTS - Champs optionnels
-- ============================================

-- S'assurer que description peut être NULL (optionnel)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'description'
    AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.restaurants ALTER COLUMN description DROP NOT NULL;
  END IF;
END $$;

-- S'assurer que logo peut être NULL (optionnel)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'logo'
    AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.restaurants ALTER COLUMN logo DROP NOT NULL;
  END IF;
END $$;

-- S'assurer que social_media peut être NULL (optionnel)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'social_media'
    AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.restaurants ALTER COLUMN social_media DROP NOT NULL;
  END IF;
END $$;

-- S'assurer que phone peut être NULL (optionnel)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'restaurants' 
    AND column_name = 'phone'
    AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.restaurants ALTER COLUMN phone DROP NOT NULL;
  END IF;
END $$;

-- ============================================
-- Mise à jour des commentaires
-- ============================================

COMMENT ON COLUMN public.clients.phone IS 'Numéro de téléphone du client (optionnel - peut être NULL)';

COMMENT ON COLUMN public.restaurants.description IS 'Description du restaurant (optionnel - peut être NULL)';
COMMENT ON COLUMN public.restaurants.logo IS 'URL du logo du restaurant (optionnel - peut être NULL)';
COMMENT ON COLUMN public.restaurants.social_media IS 'URLs des réseaux sociaux séparées par des virgules (optionnel - peut être NULL)';
COMMENT ON COLUMN public.restaurants.phone IS 'Numéro de téléphone du restaurant (optionnel - peut être NULL)';

