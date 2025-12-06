-- Script pour activer Supabase Realtime sur les tables nécessaires
-- À exécuter dans l'éditeur SQL de Supabase

-- Activer Realtime sur la table restaurants
ALTER PUBLICATION supabase_realtime ADD TABLE public.restaurants;

-- Activer Realtime sur la table deals
ALTER PUBLICATION supabase_realtime ADD TABLE public.deals;

-- Vérifier que les tables sont bien dans la publication Realtime
SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

-- Note: Pour que Realtime fonctionne, les tables doivent avoir :
-- 1. Realtime activé (ci-dessus)
-- 2. RLS (Row Level Security) configuré correctement
-- 3. Les utilisateurs doivent avoir les permissions SELECT sur les tables

