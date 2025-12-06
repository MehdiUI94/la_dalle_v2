-- Script pour corriger les politiques RLS sur la table profiles
-- ET corriger la contrainte de clé étrangère
-- Permet l'insertion publique lors de l'inscription

-- IMPORTANT: Exécutez ce script dans l'éditeur SQL de Supabase

-- 1. Supprimer la contrainte de clé étrangère vers auth.users si elle existe
-- Car nous créons directement dans clients/restaurants sans passer par auth.users
-- Cette contrainte empêche l'insertion car l'ID n'existe pas dans auth.users
DO $$
BEGIN
  -- Vérifier et supprimer la contrainte profiles_id_fkey
  IF EXISTS (
    SELECT 1 
    FROM pg_constraint 
    WHERE conname = 'profiles_id_fkey' 
    AND conrelid = 'public.profiles'::regclass
  ) THEN
    ALTER TABLE public.profiles DROP CONSTRAINT profiles_id_fkey;
    RAISE NOTICE 'Contrainte profiles_id_fkey supprimée avec succès';
  ELSE
    RAISE NOTICE 'Contrainte profiles_id_fkey n''existe pas (déjà supprimée ou jamais créée)';
  END IF;
END $$;

-- 2. Vérifier que RLS est activé sur la table profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 3. Supprimer TOUTES les politiques existantes pour repartir de zéro
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'profiles') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.profiles';
    END LOOP;
END $$;

-- 4. Créer une politique pour permettre l'insertion publique (pour l'inscription)
-- Cette politique est nécessaire car l'inscription se fait sans authentification
-- Utiliser TO public pour garantir l'accès
CREATE POLICY "profiles_allow_public_insert"
ON public.profiles
FOR INSERT
TO public
WITH CHECK (true);

-- 5. Créer une politique pour permettre la lecture publique (pour afficher les profils)
CREATE POLICY "profiles_allow_public_select"
ON public.profiles
FOR SELECT
TO public
USING (true);

-- 6. Créer une politique pour permettre la mise à jour (optionnel, vous pouvez restreindre)
-- Pour l'instant, on permet la mise à jour publique (vous pouvez restreindre plus tard)
CREATE POLICY "profiles_allow_public_update"
ON public.profiles
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- Note: Ces politiques permettent :
-- - INSERT : N'importe qui peut créer un profil (nécessaire pour l'inscription publique)
-- - SELECT : N'importe qui peut lire les profils (pour afficher les noms, etc.)
-- - UPDATE : N'importe qui peut mettre à jour (vous pouvez restreindre plus tard si nécessaire)

-- Pour vérifier que les politiques sont bien créées :
-- SELECT * FROM pg_policies WHERE tablename = 'profiles';

