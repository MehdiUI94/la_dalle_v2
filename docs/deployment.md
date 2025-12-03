# Guide de déploiement - LA DALLE

Ce guide vous explique comment publier votre application sur différentes plateformes.

## 📋 Prérequis

1. Avoir un compte GitHub (pour versionner votre code)
2. Avoir configuré vos variables d'environnement dans `.env`

## 🚀 Option 1 : Vercel (Recommandé - Le plus simple)

Vercel est gratuit et très facile à utiliser pour les applications Vue/Vite.

### Étapes :

1. **Installer Vercel CLI** (optionnel, vous pouvez aussi utiliser l'interface web)
   ```bash
   npm install -g vercel
   ```

2. **Build local pour tester**
   ```bash
   npm run build
   npm run preview
   ```

3. **Déployer sur Vercel**

   **Méthode A : Via l'interface web (plus simple)**
   - Allez sur [vercel.com](https://vercel.com)
   - Créez un compte ou connectez-vous
   - Cliquez sur "Add New Project"
   - Importez votre repository GitHub
   - Vercel détectera automatiquement Vite
   - Ajoutez vos variables d'environnement :
     - `VITE_SUPABASE_URL`
     - `VITE_SUPABASE_ANON_KEY`
   - Cliquez sur "Deploy"

   **Méthode B : Via CLI**
   ```bash
   vercel
   ```
   Suivez les instructions et ajoutez vos variables d'environnement.

4. **Votre site est en ligne !**
   Vercel vous donnera une URL du type : `https://la-dalle.vercel.app`

### Configuration automatique

Le fichier `vercel.json` est déjà configuré pour votre application Vue Router.

---

## 🌐 Option 2 : Netlify

Netlify est également gratuit et très populaire.

### Étapes :

1. **Build local pour tester**
   ```bash
   npm run build
   npm run preview
   ```

2. **Déployer sur Netlify**

   **Méthode A : Via l'interface web**
   - Allez sur [netlify.com](https://netlify.com)
   - Créez un compte ou connectez-vous
   - Cliquez sur "Add new site" → "Import an existing project"
   - Connectez votre repository GitHub
   - Netlify détectera automatiquement les paramètres depuis `netlify.toml`
   - Ajoutez vos variables d'environnement dans "Site settings" → "Environment variables" :
     - `VITE_SUPABASE_URL`
     - `VITE_SUPABASE_ANON_KEY`
   - Cliquez sur "Deploy site"

   **Méthode B : Via CLI**
   ```bash
   npm install -g netlify-cli
   netlify login
   netlify deploy --prod
   ```

3. **Votre site est en ligne !**
   Netlify vous donnera une URL du type : `https://la-dalle.netlify.app`

---

## 📦 Option 3 : GitHub Pages

Gratuit mais nécessite quelques étapes supplémentaires.

### Étapes :

1. **Installer le plugin GitHub Pages**
   ```bash
   npm install --save-dev gh-pages
   ```

2. **Ajouter un script dans package.json**
   ```json
   "scripts": {
     "deploy": "npm run build && gh-pages -d dist"
   }
   ```

3. **Modifier vite.config.ts**
   ```typescript
   export default defineConfig({
     base: '/la_dalle_v2/', // Remplacez par le nom de votre repo
     // ... reste de la config
   })
   ```

4. **Déployer**
   ```bash
   npm run deploy
   ```

5. **Activer GitHub Pages**
   - Allez dans Settings → Pages de votre repo GitHub
   - Sélectionnez la branche `gh-pages`
   - Votre site sera disponible sur : `https://votre-username.github.io/la_dalle_v2/`

---

## 🔐 Variables d'environnement

⚠️ **IMPORTANT** : N'oubliez pas d'ajouter vos variables d'environnement sur la plateforme de déploiement :

- `VITE_SUPABASE_URL` : Votre URL Supabase
- `VITE_SUPABASE_ANON_KEY` : Votre clé anonyme Supabase

Ces variables doivent être configurées dans les paramètres de votre projet sur la plateforme choisie.

---

## ✅ Vérification après déploiement

Après le déploiement, vérifiez :

1. ✅ La page d'accueil s'affiche correctement
2. ✅ La navigation fonctionne
3. ✅ La connexion Supabase fonctionne
4. ✅ La carte Leaflet s'affiche
5. ✅ Les routes fonctionnent (essayez de rafraîchir une page)

---

## 🐛 Résolution de problèmes

### Erreur 404 sur les routes

Si vous obtenez une erreur 404 en naviguant directement vers une route, c'est normal. Les fichiers de configuration (`vercel.json` et `netlify.toml`) gèrent déjà cela avec des redirections.

### Variables d'environnement non chargées

Vérifiez que vous avez bien ajouté les variables dans les paramètres de votre projet sur la plateforme.

### Build échoue

Vérifiez les logs de build sur la plateforme pour identifier l'erreur. Assurez-vous que `npm run build` fonctionne localement.

---

## 📝 Recommandation

Pour un projet comme LA DALLE, **Vercel** est la meilleure option car :
- ✅ Configuration automatique pour Vite
- ✅ Déploiement très rapide
- ✅ HTTPS automatique
- ✅ CDN global
- ✅ Gratuit pour les projets personnels

