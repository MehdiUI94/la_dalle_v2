-- Script pour ajouter le champ N° INE et ajuster la table clients pour n'accepter que des étudiants
-- À exécuter dans l'éditeur SQL de Supabase

-- ============================================
-- TABLE CLIENTS - Ajout du champ INE
-- ============================================

-- Ajouter la colonne INE si elle n'existe pas
ALTER TABLE public.clients
ADD COLUMN IF NOT EXISTS ine TEXT;

-- Mettre à jour tous les clients existants pour qu'ils soient marqués comme étudiants
UPDATE public.clients
SET is_student = TRUE
WHERE is_student IS NULL OR is_student = FALSE;

-- Ajouter la contrainte NOT NULL pour INE (après avoir mis des valeurs par défaut si nécessaire)
-- Note: Si vous avez déjà des données, vous devrez d'abord remplir les valeurs NULL
-- UPDATE public.clients SET ine = '' WHERE ine IS NULL;
-- ALTER TABLE public.clients ALTER COLUMN ine SET NOT NULL;

-- Pour l'instant, on laisse INE nullable pour permettre la migration progressive
-- Une fois toutes les données migrées, vous pouvez décommenter les lignes ci-dessus

-- Ajouter une contrainte UNIQUE sur INE pour éviter les doublons
CREATE UNIQUE INDEX IF NOT EXISTS idx_clients_ine_unique ON public.clients(ine) WHERE ine IS NOT NULL;

-- Ajouter un index pour les recherches rapides par INE
CREATE INDEX IF NOT EXISTS idx_clients_ine ON public.clients(ine);

-- Mettre à jour is_student pour qu'il soit toujours TRUE (contrainte CHECK)
ALTER TABLE public.clients
DROP CONSTRAINT IF EXISTS clients_must_be_student;

ALTER TABLE public.clients
ADD CONSTRAINT clients_must_be_student 
CHECK (is_student = TRUE);

-- Mettre is_student à TRUE par défaut
ALTER TABLE public.clients
ALTER COLUMN is_student SET DEFAULT TRUE,
ALTER COLUMN is_student SET NOT NULL;

-- Commentaire pour documentation
COMMENT ON COLUMN public.clients.ine IS 'N° INE (Identifiant National Étudiant) - Obligatoire pour tous les clients (étudiants uniquement)';
COMMENT ON COLUMN public.clients.is_student IS 'Indique si le client est étudiant (toujours TRUE - seuls les étudiants peuvent s\'inscrire)';

-- ============================================
-- Mise à jour du script adjust-database-schema.sql
-- ============================================
-- Note: Ce script complète le script adjust-database-schema.sql
-- Il ajoute le champ INE et s'assure que tous les clients sont des étudiants

