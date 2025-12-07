-- Script de vérification : Vérifier l'état actuel des tables
-- Exécutez ce script pour voir quelles tables existent et leurs noms

-- Vérifier les tables principales
SELECT 
  'Tables principales' as category,
  table_name,
  CASE 
    WHEN table_name = 'clients' THEN '⚠️ À renommer en "etudiants"'
    WHEN table_name = 'etudiants' THEN '✅ OK'
    WHEN table_name = 'client_addresses' THEN '⚠️ À renommer en "etudiant_addresses"'
    WHEN table_name = 'etudiant_addresses' THEN '✅ OK'
    ELSE '✅'
  END as status
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('clients', 'etudiants', 'client_addresses', 'etudiant_addresses', 'restaurants', 'profiles')
ORDER BY table_name;

-- Vérifier les colonnes client_id vs etudiant_id
SELECT 
  'Colonnes client_id/etudiant_id' as category,
  table_name,
  column_name,
  CASE 
    WHEN column_name = 'client_id' THEN '⚠️ À renommer en "etudiant_id"'
    WHEN column_name = 'etudiant_id' THEN '✅ OK'
  END as status
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_name IN ('client_id', 'etudiant_id')
ORDER BY table_name, column_name;

-- Vérifier les contraintes de clés étrangères
SELECT 
  'Contraintes FK' as category,
  tc.table_name,
  tc.constraint_name,
  CASE 
    WHEN constraint_name LIKE '%client%' THEN '⚠️ À mettre à jour'
    WHEN constraint_name LIKE '%etudiant%' THEN '✅ OK'
    ELSE '✅'
  END as status
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND (tc.constraint_name LIKE '%client%' OR tc.constraint_name LIKE '%etudiant%')
ORDER BY tc.table_name, tc.constraint_name;

-- Vérifier les index
SELECT 
  'Index' as category,
  indexname as index_name,
  tablename as table_name,
  CASE 
    WHEN indexname LIKE '%client%' THEN '⚠️ À renommer'
    WHEN indexname LIKE '%etudiant%' THEN '✅ OK'
    ELSE '✅'
  END as status
FROM pg_indexes
WHERE schemaname = 'public'
  AND (indexname LIKE '%client%' OR indexname LIKE '%etudiant%')
ORDER BY tablename, indexname;

-- Résumé
SELECT 
  'RÉSUMÉ' as category,
  COUNT(*) FILTER (WHERE table_name = 'clients') as tables_clients,
  COUNT(*) FILTER (WHERE table_name = 'etudiants') as tables_etudiants,
  COUNT(*) FILTER (WHERE table_name = 'client_addresses') as tables_client_addresses,
  COUNT(*) FILTER (WHERE table_name = 'etudiant_addresses') as tables_etudiant_addresses
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('clients', 'etudiants', 'client_addresses', 'etudiant_addresses');

