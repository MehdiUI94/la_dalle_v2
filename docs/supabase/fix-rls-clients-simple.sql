-- Script simple et direct pour corriger RLS sur la table clients
-- Exécutez ce script si vous obtenez toujours l'erreur RLS

-- 1. Activer RLS (si ce n'est pas déjà fait)
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- 2. Supprimer TOUTES les politiques existantes sur clients (pour repartir de zéro)
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'clients') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.clients';
    END LOOP;
END $$;

-- 3. Créer une politique pour INSERT (inscription publique)
CREATE POLICY "clients_allow_public_insert"
ON public.clients
FOR INSERT
TO public
WITH CHECK (true);

-- 4. Créer une politique pour SELECT (lecture publique)
CREATE POLICY "clients_allow_public_select"
ON public.clients
FOR SELECT
TO public
USING (true);

-- 5. Créer une politique pour UPDATE (mise à jour publique pour l'instant)
CREATE POLICY "clients_allow_public_update"
ON public.clients
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

-- Vérification
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'clients';

-- Message de confirmation
SELECT 'Politiques RLS créées pour la table clients' as status;

