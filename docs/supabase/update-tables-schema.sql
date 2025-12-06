-- Script pour mettre à jour les tables clients et restaurants avec les nouveaux champs
-- À exécuter dans l'éditeur SQL de Supabase

-- Mise à jour de la table clients
ALTER TABLE public.clients
ADD COLUMN IF NOT EXISTS firstname TEXT,
ADD COLUMN IF NOT EXISTS lastname TEXT,
ADD COLUMN IF NOT EXISTS age INTEGER,
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS phone TEXT,
ADD COLUMN IF NOT EXISTS is_student BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS notifications_email BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS notifications_phone BOOLEAN DEFAULT FALSE;

-- Mise à jour de la table restaurants
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

-- Commentaires pour documentation
COMMENT ON COLUMN public.clients.firstname IS 'Prénom du client';
COMMENT ON COLUMN public.clients.lastname IS 'Nom du client';
COMMENT ON COLUMN public.clients.age IS 'Âge du client';
COMMENT ON COLUMN public.clients.address IS 'Adresse complète du client';
COMMENT ON COLUMN public.clients.phone IS 'Numéro de téléphone du client (optionnel)';
COMMENT ON COLUMN public.clients.is_student IS 'Indique si le client est étudiant';
COMMENT ON COLUMN public.clients.notifications_email IS 'Le client souhaite recevoir des notifications par email';
COMMENT ON COLUMN public.clients.notifications_phone IS 'Le client souhaite recevoir des notifications par téléphone';

COMMENT ON COLUMN public.restaurants.owner_firstname IS 'Prénom du propriétaire du restaurant';
COMMENT ON COLUMN public.restaurants.owner_lastname IS 'Nom du propriétaire du restaurant';
COMMENT ON COLUMN public.restaurants.description IS 'Description du restaurant (optionnel)';
COMMENT ON COLUMN public.restaurants.logo IS 'URL du logo du restaurant (optionnel)';
COMMENT ON COLUMN public.restaurants.siren IS 'Numéro SIREN du restaurant';
COMMENT ON COLUMN public.restaurants.siret IS 'Numéro SIRET du restaurant';
COMMENT ON COLUMN public.restaurants.social_media IS 'URLs des réseaux sociaux séparées par des virgules (optionnel)';
COMMENT ON COLUMN public.restaurants.notifications_email IS 'Le restaurant souhaite recevoir des notifications par email';
COMMENT ON COLUMN public.restaurants.notifications_phone IS 'Le restaurant souhaite recevoir des notifications par téléphone';

