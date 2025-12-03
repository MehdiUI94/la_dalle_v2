# 🚀 Déploiement Rapide - LA DALLE

## Méthode la plus simple : Vercel (5 minutes)

### 1. Préparer votre code

Assurez-vous que votre code est sur GitHub :
```bash
git add .
git commit -m "Prêt pour déploiement"
git push origin main
```

### 2. Déployer sur Vercel

1. Allez sur **[vercel.com](https://vercel.com)** et créez un compte (gratuit)
2. Cliquez sur **"Add New Project"**
3. Importez votre repository GitHub `la_dalle_v2`
4. Vercel détectera automatiquement Vite ✅
5. **IMPORTANT** : Ajoutez vos variables d'environnement :
   - Cliquez sur **"Environment Variables"**
   - Ajoutez :
     - `VITE_SUPABASE_URL` = votre URL Supabase
     - `VITE_SUPABASE_ANON_KEY` = votre clé anonyme Supabase
6. Cliquez sur **"Deploy"**

### 3. C'est fait ! 🎉

Votre site sera disponible sur : `https://la-dalle-v2.vercel.app` (ou un nom similaire)

---

## Alternative : Netlify

1. Allez sur **[netlify.com](https://netlify.com)**
2. "Add new site" → "Import an existing project"
3. Connectez GitHub et sélectionnez votre repo
4. Ajoutez les variables d'environnement dans "Site settings"
5. Deploy !

---

## ⚠️ Important

N'oubliez pas d'ajouter vos variables d'environnement sur la plateforme :
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

Sans ces variables, votre application ne pourra pas se connecter à Supabase.

---

## 📝 Vérification

Après le déploiement, testez :
- ✅ Page d'accueil
- ✅ Connexion client/restaurant
- ✅ Carte interactive
- ✅ Navigation entre les pages

---

Pour plus de détails, consultez `docs/deployment.md`

