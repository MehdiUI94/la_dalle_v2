# Configuration des variables d'environnement

## Fichier .env

Pour que l'application fonctionne avec Supabase, vous devez créer un fichier `.env` à la racine du projet.

### Étapes :

1. **Créer le fichier .env**

À la racine du projet (même niveau que `package.json`), créer un fichier nommé `.env`

2. **Ajouter les variables**

```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre-anon-key-ici
```

3. **Remplacer les valeurs**

   - Aller sur votre projet Supabase
   - Cliquer sur **Settings** → **API**
   - Copier :
     - **Project URL** → `VITE_SUPABASE_URL`
     - **anon/public key** → `VITE_SUPABASE_ANON_KEY`

4. **Redémarrer le serveur**

Si le serveur dev est déjà lancé :

```bash
# Arrêter avec Ctrl+C
# Relancer
npm run dev
```

## Mode test (sans Supabase)

Si vous voulez tester l'application SANS configurer Supabase :

1. Ne créez pas le fichier `.env`
2. L'application affichera un warning dans la console mais fonctionnera quand même
3. Utilisez les boutons "Connexion test" sur la page `/login`

## Sécurité

⚠️ **IMPORTANT** :
- Le fichier `.env` ne doit JAMAIS être commité dans Git
- Il est déjà dans `.gitignore`
- Ne partagez JAMAIS vos clés Supabase publiquement

