# Supabase

## Configuration

- URL et clés dans `.env`
- Client initialisé dans `src/lib/supabaseClient.ts`

## Schéma de base de données

- Tables principales : `profiles`, `clients`, `restaurants`, `deals`, `favorites`
- RLS (Row Level Security) activé sur toutes les tables
- Triggers pour `updated_at` automatique

## Authentification

- Gestion directe via les tables `clients` et `restaurants`
- Session stockée dans `localStorage`
- Pas d'utilisation de `auth.users` directement

## Realtime

- Activé sur `restaurants` et `deals`
- Utilisé pour les mises à jour en temps réel de la carte

## Bonnes pratiques

- Toujours gérer les erreurs
- Utiliser TypeScript types générés depuis Supabase
- Vérifier les permissions RLS avant les requêtes



