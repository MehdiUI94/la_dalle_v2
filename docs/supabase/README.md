# Scripts SQL Supabase

Ce dossier contient les scripts SQL nécessaires pour configurer la base de données.

## Scripts à exécuter (dans l'ordre)

### 1. Configuration de base
- `fix-rls-clients-restaurants-clean.sql` - Configuration RLS pour les tables etudiants et restaurants
- `enable-realtime.sql` - Activation du Realtime pour les tables nécessaires
- `setup-storage.sql` - Configuration du stockage pour les images

### 2. Tables principales
- `create-restaurant-ratings-table.sql` - Table pour les notes des restaurants
- `create-restaurant-visits-table.sql` - Table pour les visites vérifiées (QR codes)
- `create-restaurant-orders-table.sql` - Table pour suivre les commandes et récompenses (10 commandes = récompense gratuite)
- `setup-etudiant-addresses.sql` - Table pour les adresses des étudiants (contient aussi les données de test)

### 3. Migration (si vous avez déjà une base de données avec "clients")
- `check-tables-status.sql` - **EXÉCUTEZ D'ABORD** : Script de vérification pour voir l'état actuel de vos tables
- `migrate-client-to-etudiant.sql` - Script de migration pour renommer "clients" en "etudiants" et toutes les références associées

**⚠️ IMPORTANT** : Si vos tables s'appellent encore "clients" et "client_addresses", vous devez exécuter le script de migration `migrate-client-to-etudiant.sql` dans Supabase SQL Editor.

### 3. Scripts de migration (si nécessaire)
- `adjust-database-schema.sql` - Ajustement du schéma de base de données
- `update-tables-schema.sql` - Mise à jour des tables avec nouveaux champs
- `fix-optional-fields.sql` - Correction des champs optionnels
- `add-ine-field.sql` - Ajout du champ INE pour les étudiants

## Notes

- Les scripts avec le suffixe `-clean` sont les versions finales à utiliser
- Les scripts de migration peuvent être exécutés plusieurs fois sans problème (utilisent `IF NOT EXISTS`)
- Consultez `realtime-setup.md` pour plus d'informations sur la configuration Realtime

