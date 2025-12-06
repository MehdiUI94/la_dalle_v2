-- Script pour corriger les politiques RLS sur les tables clients et restaurants
-- Permet l'insertion publique lors de l'inscription

-- IMPORTANT: Exécutez ce script dans l'éditeur SQL de Supabase

-- ============================================
-- TABLE CLIENTS
-- ============================================

-- 1. Vérifier que RLS est activé sur la table clients
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer TOUTES les politiques existantes pour repartir de zéro
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'clients') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.clients';
    END LOOP;
END $$;

-- 3. Créer une politique pour permettre l'insertion publique (pour l'inscription)
-- Utiliser TO public pour garantir l'accès
CREATE POLICY "clients_allow_public_insert"
ON public.clients
FOR INSERT
TO public
WITH CHECK (true);

-- 4. Créer une politique pour permettre la lecture publique (pour afficher les profils)
CREATE POLICY "clients_allow_public_select"
ON public.clients
FOR SELECT
TO public
USING (true);

-- 5. Créer une politique pour permettre la mise à jour (vous pouvez restreindre plus tard)
CREATE POLICY "clients_allow_public_update"
ON public.clients
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- ============================================
-- TABLE RESTAURANTS
-- ============================================

-- 1. Vérifier que RLS est activé sur la table restaurants
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer TOUTES les politiques existantes pour repartir de zéro
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'restaurants') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.restaurants';
    END LOOP;
END $$;

-- 3. Créer une politique pour permettre l'insertion publique (pour l'inscription)
-- Utiliser TO public pour garantir l'accès
CREATE POLICY "restaurants_allow_public_insert"
ON public.restaurants
FOR INSERT
TO public
WITH CHECK (true);

-- 4. Créer une politique pour permettre la lecture publique (pour afficher les restaurants)
CREATE POLICY "restaurants_allow_public_select"
ON public.restaurants
FOR SELECT
TO public
USING (true);

-- 5. Créer une politique pour permettre la mise à jour (vous pouvez restreindre plus tard)
CREATE POLICY "restaurants_allow_public_update"
ON public.restaurants
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- ============================================
-- VÉRIFICATION
-- ============================================

-- Vérifier que les politiques sont bien créées
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename IN ('clients', 'restaurants')
ORDER BY tablename, policyname;

-- Note: Ces politiques permettent :
-- - INSERT : N'importe qui peut créer un client/restaurant (nécessaire pour l'inscription publique)
-- - SELECT : N'importe qui peut lire les clients/restaurants (pour afficher les informations)
-- - UPDATE : N'importe qui peut mettre à jour (vous pouvez restreindre plus tard si nécessaire)

-- Pour restreindre UPDATE à seulement son propre profil, vous pouvez modifier les politiques UPDATE pour utiliser l'ID :
-- CREATE POLICY "Allow users to update their own client profile"
-- ON public.clients
-- FOR UPDATE
-- USING (id = current_setting('app.current_user_id', true)::uuid)
-- WITH CHECK (id = current_setting('app.current_user_id', true)::uuid);

