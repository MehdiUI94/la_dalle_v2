# Guide de Test de Connexion Supabase

## Configuration

1. Ouvrez le fichier `.env` à la racine du projet
2. Remplacez les valeurs par vos vraies clés Supabase :

```
VITE_SUPABASE_URL=https://votre-projet-id.supabase.co
VITE_SUPABASE_ANON_KEY=votre_vraie_cle_anon_supabase
```

## Test de Connexion

Une fois le fichier `.env` configuré avec vos vraies clés :

1. Redémarrez le serveur de développement :
   ```bash
   npm run dev
   ```

2. Ouvrez la console du navigateur (F12)
3. Allez sur la page de connexion ou d'inscription
4. Vérifiez qu'il n'y a pas d'erreurs Supabase dans la console

## Vérification des Tables

Pour vérifier que vos tables existent, vous pouvez utiliser le SQL Editor dans Supabase :

```sql
-- Vérifier que les tables existent
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'etudiants', 'restaurants', 'deals', 'favorites');
```

## Tables Requises

Assurez-vous que ces tables existent dans votre base Supabase :
- ✅ `profiles`
- ✅ `etudiants`
- ✅ `restaurants`
- ✅ `deals`
- ✅ `favorites`
- ✅ `restaurant_visits`
- ✅ `restaurant_orders`
- ✅ `restaurant_ratings`
- ✅ `rating_notifications`
- ✅ `etudiant_addresses`

