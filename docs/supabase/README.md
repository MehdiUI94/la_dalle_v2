# Documentation Supabase - LA DALLE

## Vue d'ensemble

LA DALLE utilise Supabase pour :
- **Authentification** : gestion des utilisateurs (clients et restaurants)
- **Base de données** : stockage des profils, deals, restaurants
- **Real-time** : mises à jour en temps réel des deals

## Configuration

### 1. Créer un projet Supabase

1. Aller sur [https://supabase.com](https://supabase.com)
2. Créer un nouveau projet
3. Récupérer :
   - `Project URL` (VITE_SUPABASE_URL)
   - `anon/public key` (VITE_SUPABASE_ANON_KEY)

### 2. Variables d'environnement

Créer un fichier `.env` à la racine :

```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre-anon-key
```

## Architecture des données

Voir `docs/supabase/schema.sql` pour le schéma complet.

### Tables principales

1. **profiles** : informations de base (role: client ou restaurant)
2. **clients** : données spécifiques aux clients
3. **restaurants** : données spécifiques aux restaurants
4. **deals** : offres "1+1" créées par les restaurants

## Sécurité

### Row Level Security (RLS)

Toutes les tables utilisent RLS pour protéger les données :
- Les clients peuvent lire tous les deals mais uniquement modifier leur profil
- Les restaurants peuvent modifier leurs deals et leur profil
- Les admins ont accès complet

### Modes de connexion

- **Production** : authentification réelle via Supabase Auth
- **Test** : connexion rapide sans Supabase pour le développement

## Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Guide Auth](https://supabase.com/docs/guides/auth)
- [RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)

