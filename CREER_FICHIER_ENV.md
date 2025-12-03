# 📝 CRÉER LE FICHIER .env POUR CONNECTER SUPABASE

## ⚠️ Important
Je ne peux pas créer le fichier `.env` automatiquement (il est protégé). Tu dois le créer manuellement. Suis ces étapes simples :

---

## 🎯 Étape par Étape

### 1. Créer un nouveau fichier

**Dans VS Code/Cursor :**

1. Clique sur **"Nouveau fichier"** (icône avec un + à côté de la racine du projet)
   
   OU
   
2. Menu → **Fichier** → **Nouveau fichier**

### 2. Nommer le fichier

Nom du fichier : **`.env`** (avec le point au début)

⚠️ **Attention :** 
- Le nom doit être exactement `.env`
- Avec le point au début
- Pas d'extension (pas `.env.txt`)
- À la **racine du projet** (même niveau que `package.json`)

### 3. Copier ce contenu

Ouvre le fichier `env-template.txt` qui est dans ton projet, et copie-colle ce contenu dans ton nouveau fichier `.env` :

```env
VITE_SUPABASE_URL=YOUR_SUPABASE_URL_HERE
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY_HERE
```

### 4. Récupérer tes clés Supabase

#### 4.1 Aller sur Supabase
👉 https://app.supabase.com

#### 4.2 Sélectionner ton projet `la_dalle`

#### 4.3 Aller dans Settings → API
- Menu gauche → **Settings** (⚙️)
- Sous-menu → **API**

#### 4.4 Copier le Project URL
Tu verras une section **"Project URL"** :
```
https://xxxxxxxxxx.supabase.co
```
→ **COPIE cette URL**

#### 4.5 Copier la clé anon public
Plus bas, section **"Project API keys"** :
- Cherche la ligne avec **`anon`** **`public`**
- Clique sur l'icône 📋 pour copier
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...
```
→ **COPIE cette clé** (elle est très longue)

### 5. Remplacer les valeurs dans .env

Dans ton fichier `.env`, remplace :

**AVANT :**
```env
VITE_SUPABASE_URL=YOUR_SUPABASE_URL_HERE
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY_HERE
```

**APRÈS :**
```env
VITE_SUPABASE_URL=https://xxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...
```

⚠️ **Important :**
- Pas d'espaces au début ou à la fin
- Pas de guillemets autour des valeurs
- La clé est TRÈS longue (normal)

### 6. Sauvegarder
**Ctrl+S** ou **Cmd+S**

---

## 🔄 Redémarrer le serveur

Dans le terminal :

1. **Arrêter** : `Ctrl+C`
2. **Relancer** : `npm run dev`

---

## ✅ Vérifier que ça marche

### Dans le navigateur (F12 pour ouvrir la console)

Si tu **NE VOIS PAS** le warning `⚠️ Supabase credentials not found` :
→ ✅ **C'EST CONNECTÉ !**

### Test création de compte

1. Va sur `/login`
2. Crée un compte test
3. Vérifie dans Supabase → Table Editor → `profiles`
4. Tu devrais voir ton compte → ✅ **ÇA MARCHE !**

---

## 🎉 Résultat attendu

Ton fichier `.env` final doit ressembler à ça :

```env
VITE_SUPABASE_URL=https://abcdefghijklmnop.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTcwMDAwMDAwMCwiZXhwIjoyMDE1NTc2MDAwfQ.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## ❌ Problèmes ?

### "Je ne trouve pas Settings → API"
→ Assure-toi d'être dans TON projet (pas la page d'accueil de Supabase)

### "Invalid API key"
→ La clé n'est pas complète (elle doit être très longue)
→ Copie-la à nouveau, parfois il manque la fin

### Le warning apparaît encore
→ Le fichier `.env` n'est pas à la racine
→ Le serveur n'a pas été redémarré
→ Le nom du fichier est incorrect (doit être `.env` exactement)

---

## 📍 Structure finale

```
la_dalle_v2/
├── .env  ← TON NOUVEAU FICHIER ICI !
├── package.json
├── vite.config.ts
├── src/
└── ...
```

Le fichier `.env` doit être **au même niveau** que `package.json`.

---

🆘 **Besoin d'aide ?** Dis-moi où tu bloques !

