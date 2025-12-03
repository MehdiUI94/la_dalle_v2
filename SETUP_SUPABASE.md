# 🚀 CONNECTER TON PROJET À SUPABASE

## Étape 1 : Récupérer tes clés Supabase

### 1.1 Aller sur Supabase
👉 Va sur [https://app.supabase.com](https://app.supabase.com)

### 1.2 Sélectionner ton projet
- Clique sur ton projet `la_dalle`
- Tu arrives sur le dashboard

### 1.3 Aller dans Settings → API
1. Clique sur **Settings** (⚙️) dans le menu de gauche
2. Clique sur **API** dans le sous-menu

### 1.4 Copier tes clés

Tu verras deux informations importantes :

#### **Project URL** (en haut)
```
https://xxxxxxxxxxxxx.supabase.co
```
→ **COPIE CETTE URL** 📋

#### **Project API keys** (plus bas)
Cherche la section avec plusieurs clés. Tu veux la clé **`anon`** **`public`** :

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6...
```
→ **COPIE CETTE CLÉ** 📋 (elle est très longue, c'est normal)

---

## Étape 2 : Mettre à jour le fichier .env

### 2.1 Ouvrir le fichier .env
- Dans VS Code/Cursor, ouvre le fichier `.env` à la racine du projet
- Tu devrais voir :

```env
VITE_SUPABASE_URL=YOUR_SUPABASE_URL_HERE
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY_HERE
```

### 2.2 Remplacer les valeurs

**Remplace** `YOUR_SUPABASE_URL_HERE` par ton Project URL :

```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
```

**Remplace** `YOUR_SUPABASE_ANON_KEY_HERE` par ta clé anon :

```env
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2.3 Sauvegarder
- **Ctrl+S** pour sauvegarder le fichier

---

## Étape 3 : Redémarrer le serveur

### Dans le terminal :

1. **Arrêter le serveur** : Appuie sur **Ctrl+C**
2. **Relancer** : 
```bash
npm run dev
```

---

## Étape 4 : Vérifier que ça fonctionne

### Test 1 : Console du navigateur
1. Ouvre `http://localhost:5173`
2. Appuie sur **F12** (ouvre la console)
3. **Si tu ne vois PAS** le message `⚠️ Supabase credentials not found` → ✅ C'est connecté !
4. **Si tu vois** le warning → ❌ Le `.env` n'est pas lu, vérifie les étapes

### Test 2 : Créer un compte
1. Va sur `http://localhost:5173/login`
2. Clique sur **"Pas encore de compte ? S'inscrire"**
3. Remplis le formulaire :
   - Email : `test@example.com`
   - Password : `test123456`
   - Sélectionne **"Client"**
4. Clique sur **"Créer mon compte"**
5. Si ça fonctionne → tu es redirigé vers `/onboarding/client` ✅

### Test 3 : Vérifier dans Supabase
1. Retourne sur [app.supabase.com](https://app.supabase.com)
2. Va dans **Table Editor** (menu de gauche)
3. Clique sur la table **`profiles`**
4. **Tu devrais voir ton compte** avec l'email `test@example.com` ✅

---

## 🎉 C'est fait !

Si tout fonctionne :
- ✅ Ton projet est connecté à Supabase
- ✅ Les comptes sont créés dans ta base de données
- ✅ Tu peux continuer le développement

---

## ❌ Problèmes courants

### "Invalid API key"
→ Vérifie que tu as bien copié la **clé complète** (elle est très longue)
→ Pas d'espaces au début ou à la fin

### "relation does not exist"
→ Tu n'as pas encore exécuté le fichier `schema.sql` dans Supabase
→ Va dans **SQL Editor** → Copie le contenu de `docs/supabase/schema.sql` → **Run**

### Le warning "⚠️ Supabase credentials not found" apparaît encore
→ Le fichier `.env` n'est pas au bon endroit (il doit être à la racine)
→ Redémarre le serveur (`npm run dev`)
→ Vérifie que le fichier s'appelle bien `.env` (avec le point au début)

---

## 🆘 Besoin d'aide ?

Si tu es bloqué, vérifie :
1. Le fichier `.env` est à la racine (même niveau que `package.json`)
2. Les valeurs sont entre guillemets ? **NON** → pas de guillemets !
3. Le serveur a été redémarré

Demande de l'aide si besoin !

