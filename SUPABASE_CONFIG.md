# Configuration Supabase - Clés Enregistrées

## Clés Supabase Configurées

**URL du Projet Supabase:**
```
https://wurxzczpxunnkjkjwhqm.supabase.co
```

**Clé Anonyme (Anon Key):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind1cnh6Y3pweHVubmtqa2p3aHFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NTYwMzYsImV4cCI6MjA4MDMzMjAzNn0.TtuJjpMRfD4UianGcCi4oKCJ2IpRYGwM7qSwIhss99g
```

## Fichier .env

Ces clés sont enregistrées dans le fichier `.env` à la racine du projet et seront automatiquement chargées à chaque lancement du serveur de développement.

## Utilisation

Les clés sont chargées automatiquement via `src/lib/supabaseClient.ts` qui lit les variables d'environnement `VITE_SUPABASE_URL` et `VITE_SUPABASE_ANON_KEY`.

## Important

⚠️ **Redémarrez toujours le serveur après modification du fichier .env**
```bash
npm run dev
```

Les variables d'environnement Vite ne sont chargées qu'au démarrage du serveur.

