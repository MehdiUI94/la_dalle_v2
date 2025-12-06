-- Script pour ajuster la base de données selon les formulaires d'inscription
-- À exécuter dans l'éditeur SQL de Supabase
-- Ce script ajoute les colonnes manquantes et définit les contraintes NOT NULL pour les champs obligatoires

-- ============================================
-- TABLE CLIENTS
-- ============================================

-- Ajouter les colonnes si elles n'existent pas
ALTER TABLE public.clients
ADD COLUMN IF NOT EXISTS firstname TEXT,
ADD COLUMN IF NOT EXISTS lastname TEXT,
ADD COLUMN IF NOT EXISTS age INTEGER,
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS phone TEXT,
ADD COLUMN IF NOT EXISTS is_student BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS notifications_email BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS notifications_phone BOOLEAN DEFAULT FALSE;

-- Mettre à jour les colonnes existantes pour ajouter NOT NULL aux champs obligatoires
-- Note: On ne peut pas ajouter NOT NULL directement si des valeurs NULL existent
-- Il faut d'abord mettre une valeur par défaut, puis ajouter la contrainte

-- Pour firstname et lastname (obligatoires)
UPDATE public.clients SET firstname = '' WHERE firstname IS NULL;
UPDATE public.clients SET lastname = '' WHERE lastname IS NULL;
ALTER TABLE public.clients
ALTER COLUMN firstname SET NOT NULL,
ALTER COLUMN lastname SET NOT NULL;

-- Pour age (obligatoire)
UPDATE public.clients SET age = 18 WHERE age IS NULL;
ALTER TABLE public.clients
ALTER COLUMN age SET NOT NULL;

-- Pour address (obligatoire)
UPDATE public.clients SET address = '' WHERE address IS NULL;
ALTER TABLE public.clients
ALTER COLUMN address SET NOT NULL;

-- Pour phone (optionnel - laisser NULL autorisé)
-- Pas de contrainte NOT NULL pour phone car c'est optionnel

-- Pour is_student (défaut FALSE)
ALTER TABLE public.clients
ALTER COLUMN is_student SET DEFAULT FALSE,
ALTER COLUMN is_student SET NOT NULL;

-- Pour notifications_email et notifications_phone (défaut FALSE, mais au moins un doit être true)
ALTER TABLE public.clients
ALTER COLUMN notifications_email SET DEFAULT FALSE,
ALTER COLUMN notifications_email SET NOT NULL,
ALTER COLUMN notifications_phone SET DEFAULT FALSE,
ALTER COLUMN notifications_phone SET NOT NULL;

-- Contrainte CHECK : au moins une notification doit être activée
ALTER TABLE public.clients
DROP CONSTRAINT IF EXISTS clients_at_least_one_notification;

ALTER TABLE public.clients
ADD CONSTRAINT clients_at_least_one_notification 
CHECK (notifications_email = TRUE OR notifications_phone = TRUE);

-- ============================================
-- TABLE RESTAURANTS
-- ============================================

-- Ajouter les colonnes si elles n'existent pas
ALTER TABLE public.restaurants
ADD COLUMN IF NOT EXISTS owner_firstname TEXT,
ADD COLUMN IF NOT EXISTS owner_lastname TEXT,
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS logo TEXT,
ADD COLUMN IF NOT EXISTS siren TEXT,
ADD COLUMN IF NOT EXISTS siret TEXT,
ADD COLUMN IF NOT EXISTS social_media TEXT,
ADD COLUMN IF NOT EXISTS notifications_email BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS notifications_phone BOOLEAN DEFAULT FALSE;

-- Pour owner_firstname et owner_lastname (obligatoires)
UPDATE public.restaurants SET owner_firstname = '' WHERE owner_firstname IS NULL;
UPDATE public.restaurants SET owner_lastname = '' WHERE owner_lastname IS NULL;
ALTER TABLE public.restaurants
ALTER COLUMN owner_firstname SET NOT NULL,
ALTER COLUMN owner_lastname SET NOT NULL;

-- Pour name (déjà existant mais doit être NOT NULL)
UPDATE public.restaurants SET name = 'Nouveau Restaurant' WHERE name IS NULL;
ALTER TABLE public.restaurants
ALTER COLUMN name SET NOT NULL;

-- Pour address (obligatoire)
UPDATE public.restaurants SET address = '' WHERE address IS NULL;
ALTER TABLE public.restaurants
ALTER COLUMN address SET NOT NULL;

-- Pour description, logo, social_media, phone (optionnels - laisser NULL autorisé)
-- Pas de contrainte NOT NULL pour ces champs car ils sont optionnels

-- Pour siren et siret (obligatoires)
UPDATE public.restaurants SET siren = '' WHERE siren IS NULL;
UPDATE public.restaurants SET siret = '' WHERE siret IS NULL;
ALTER TABLE public.restaurants
ALTER COLUMN siren SET NOT NULL,
ALTER COLUMN siret SET NOT NULL;

-- Pour notifications_email et notifications_phone (défaut FALSE, mais au moins un doit être true)
ALTER TABLE public.restaurants
ALTER COLUMN notifications_email SET DEFAULT FALSE,
ALTER COLUMN notifications_email SET NOT NULL,
ALTER COLUMN notifications_phone SET DEFAULT FALSE,
ALTER COLUMN notifications_phone SET NOT NULL;

-- Contrainte CHECK : au moins une notification doit être activée
ALTER TABLE public.restaurants
DROP CONSTRAINT IF EXISTS restaurants_at_least_one_notification;

ALTER TABLE public.restaurants
ADD CONSTRAINT restaurants_at_least_one_notification 
CHECK (notifications_email = TRUE OR notifications_phone = TRUE);

-- ============================================
-- COMMENTAIRES POUR DOCUMENTATION
-- ============================================

COMMENT ON COLUMN public.clients.firstname IS 'Prénom du client (obligatoire)';
COMMENT ON COLUMN public.clients.lastname IS 'Nom du client (obligatoire)';
COMMENT ON COLUMN public.clients.age IS 'Âge du client (obligatoire)';
COMMENT ON COLUMN public.clients.address IS 'Adresse complète du client (obligatoire)';
COMMENT ON COLUMN public.clients.phone IS 'Numéro de téléphone du client (optionnel)';
COMMENT ON COLUMN public.clients.is_student IS 'Indique si le client est étudiant (défaut: FALSE)';
COMMENT ON COLUMN public.clients.notifications_email IS 'Le client souhaite recevoir des notifications par email (obligatoire: au moins email ou phone)';
COMMENT ON COLUMN public.clients.notifications_phone IS 'Le client souhaite recevoir des notifications par téléphone (obligatoire: au moins email ou phone)';

COMMENT ON COLUMN public.restaurants.owner_firstname IS 'Prénom du propriétaire du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.owner_lastname IS 'Nom du propriétaire du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.name IS 'Nom du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.address IS 'Adresse du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.description IS 'Description du restaurant (optionnel)';
COMMENT ON COLUMN public.restaurants.logo IS 'URL du logo du restaurant (optionnel)';
COMMENT ON COLUMN public.restaurants.siren IS 'Numéro SIREN du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.siret IS 'Numéro SIRET du restaurant (obligatoire)';
COMMENT ON COLUMN public.restaurants.social_media IS 'URLs des réseaux sociaux séparées par des virgules (optionnel)';
COMMENT ON COLUMN public.restaurants.notifications_email IS 'Le restaurant souhaite recevoir des notifications par email (obligatoire: au moins email ou phone)';
COMMENT ON COLUMN public.restaurants.notifications_phone IS 'Le restaurant souhaite recevoir des notifications par téléphone (obligatoire: au moins email ou phone)';

-- ============================================
-- INDEX POUR PERFORMANCE
-- ============================================

-- Index sur email pour les recherches rapides
CREATE INDEX IF NOT EXISTS idx_clients_email ON public.clients(email);
CREATE INDEX IF NOT EXISTS idx_restaurants_email ON public.restaurants(email);

-- Index sur les noms pour les recherches
CREATE INDEX IF NOT EXISTS idx_clients_name ON public.clients(lastname, firstname);
CREATE INDEX IF NOT EXISTS idx_restaurants_name ON public.restaurants(name);

