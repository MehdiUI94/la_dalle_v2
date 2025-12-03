# Guide Débutant : Accéder à Supabase

## 🎯 Objectif

Ce guide te montre comment créer un compte Supabase et accéder à ta base de données pour LA DALLE.

---

## Étape 1 : Créer un compte Supabase

1. **Aller sur** [https://supabase.com](https://supabase.com)

2. **Cliquer sur "Start your project"** (en haut à droite)

3. **S'inscrire** avec :
   - GitHub (recommandé si tu as un compte GitHub)
   - Email (sinon, utilise ton email)

4. **Confirmer ton email** si nécessaire

---

## Étape 2 : Créer un nouveau projet

Une fois connecté :

1. **Cliquer sur "New Project"** (bouton vert)

2. **Remplir le formulaire** :
   - **Organization** : Choisir "Personal" ou créer une nouvelle organisation
   - **Name** : `la-dalle` (ou le nom que tu veux)
   - **Database Password** : ⚠️ **IMPORTANT** - Choisir un mot de passe fort et le **SAUVEGARDER** quelque part (tu en auras besoin plus tard)
   - **Region** : Choisir `Europe West (Frankfurt)` ou la plus proche de Paris
   - **Pricing Plan** : Free (gratuit pour commencer)

3. **Cliquer sur "Create new project"**

4. ⏳ **Attendre 2-3 minutes** que le projet soit créé (tu verras une barre de progression)

---

## Étape 3 : Accéder à ton projet

Une fois le projet créé, tu arrives sur le **Dashboard** de ton projet.

Tu verras plusieurs sections dans le menu de gauche :

```
📊 Dashboard (accueil)
🔐 Authentication (gestion des utilisateurs)
📋 Table Editor (voir/modifier les données)
🔧 SQL Editor (exécuter du code SQL)
⚙️ Settings (paramètres)
```

---

## Étape 4 : Créer les tables (exécuter le schéma SQL)

### 4.1 Ouvrir le SQL Editor

1. **Cliquer sur "SQL Editor"** dans le menu de gauche
2. Tu verras une interface avec un éditeur de code

### 4.2 Copier le schéma SQL

1. **Ouvrir le fichier** `docs/supabase/schema.sql` dans ton projet
2. **Sélectionner TOUT le contenu** (Ctrl+A)
3. **Copier** (Ctrl+C)

### 4.3 Coller et exécuter

1. **Revenir sur Supabase** (dans le SQL Editor)
2. **Coller le code** dans l'éditeur (Ctrl+V)
3. **Cliquer sur "Run"** (bouton ▶️ en bas à droite) ou appuyer sur **Ctrl+Enter**

4. ✅ Tu devrais voir un message de succès : "Success. No rows returned"

### 4.4 Vérifier que les tables sont créées

1. **Cliquer sur "Table Editor"** dans le menu de gauche
2. Tu devrais voir **5 tables** :
   - `profiles`
   - `clients`
   - `restaurants`
   - `deals`
   - `favorites`

🎉 **Bravo !** Ta base de données est maintenant configurée !

---

## Étape 5 : Récupérer tes clés API

Pour connecter ton application Vue à Supabase, tu as besoin de 2 clés :

### 5.1 Aller dans Settings

1. **Cliquer sur "Settings"** (⚙️) dans le menu de gauche
2. **Cliquer sur "API"** dans le sous-menu

### 5.2 Copier les clés

Tu verras deux sections importantes :

#### **Project URL**
```
https://xxxxxxxxxxxxx.supabase.co
```
→ **Copier cette URL**

#### **Project API keys**
Tu verras plusieurs clés, cherche :
- **`anon` `public`** (c'est celle qu'on utilise)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```
→ **Copier cette clé** (elle commence par `eyJ...`)

### 5.3 Créer le fichier .env

1. **Retourner dans ton projet** (dans VS Code ou ton éditeur)

2. **Créer un fichier `.env`** à la racine du projet (même niveau que `package.json`)

3. **Coller ce contenu** et remplacer avec TES valeurs :

```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

4. **Sauvegarder** le fichier

---

## Étape 6 : Voir et gérer tes données

### Table Editor (interface visuelle)

1. **Cliquer sur "Table Editor"** dans le menu
2. **Cliquer sur une table** (ex: `profiles`)
3. Tu verras les colonnes et les données (vide pour l'instant)

**Actions possibles** :
- ➕ **Insert row** : Ajouter une ligne manuellement
- ✏️ **Edit** : Modifier une ligne
- 🗑️ **Delete** : Supprimer une ligne

### SQL Editor (requêtes avancées)

1. **Cliquer sur "SQL Editor"**
2. **Écrire une requête SQL**, par exemple :

```sql
-- Voir tous les profils
SELECT * FROM profiles;

-- Voir tous les restaurants
SELECT * FROM restaurants;

-- Voir tous les deals actifs
SELECT * FROM deals WHERE is_active = true;
```

3. **Cliquer sur "Run"** pour exécuter

---

## 🎓 Concepts importants pour débutants

### Qu'est-ce qu'une table ?
Une table = un tableau Excel avec des colonnes et des lignes.

Exemple : Table `restaurants`
```
| id  | name          | address              | arrondissement |
|-----|---------------|----------------------|----------------|
| 1   | Pizza Paradise| 123 rue de la Paix   | 11ème          |
| 2   | Burger House  | 456 avenue des Champs| 3ème           |
```

### Qu'est-ce qu'une ligne (row) ?
Une ligne = un enregistrement (ex: un restaurant, un client, un deal)

### Qu'est-ce qu'une colonne (column) ?
Une colonne = un champ d'information (ex: nom, adresse, prix)

### Qu'est-ce que SQL ?
SQL = langage pour parler à la base de données

Exemples :
- `SELECT * FROM restaurants` = "Montre-moi tous les restaurants"
- `INSERT INTO restaurants (name) VALUES ('Pizza Test')` = "Ajoute un restaurant"
- `DELETE FROM restaurants WHERE id = 1` = "Supprime le restaurant avec l'id 1"

---

## 🔍 Vérifier que tout fonctionne

### Test 1 : Vérifier la connexion depuis l'app

1. **Redémarrer ton serveur dev** :
   ```bash
   npm run dev
   ```

2. **Aller sur** `http://localhost:5173/login`

3. **Essayer de créer un compte** :
   - Email : `test@example.com`
   - Password : `test123456`
   - Sélectionner "Client"

4. **Vérifier dans Supabase** :
   - Aller dans **Table Editor** → **profiles**
   - Tu devrais voir une nouvelle ligne avec ton email !

### Test 2 : Voir les données dans Supabase

1. **Table Editor** → **profiles** → Tu vois ton profil
2. **Table Editor** → **clients** → Tu vois tes infos client (après onboarding)

---

## 🆘 Problèmes courants

### "Invalid API key"
→ Vérifier que le fichier `.env` contient les bonnes clés
→ Redémarrer le serveur (`npm run dev`)

### "relation does not exist"
→ Les tables n'ont pas été créées
→ Réexécuter le fichier `schema.sql` dans SQL Editor

### "permission denied"
→ Normal si tu essaies de modifier des données d'un autre utilisateur
→ C'est la sécurité (RLS) qui fonctionne !

### Je ne trouve pas mes clés API
→ Settings → API → Section "Project API keys"
→ Chercher la clé `anon` `public`

---

## 📚 Ressources utiles

- **Documentation Supabase** : [https://supabase.com/docs](https://supabase.com/docs)
- **SQL Tutorial** : [https://www.w3schools.com/sql/](https://www.w3schools.com/sql/)
- **Discord Supabase** : Pour poser des questions à la communauté

---

## ✅ Checklist de démarrage

- [ ] Compte Supabase créé
- [ ] Projet créé
- [ ] Schéma SQL exécuté (5 tables créées)
- [ ] Clés API copiées
- [ ] Fichier `.env` créé avec les bonnes valeurs
- [ ] Serveur redémarré
- [ ] Test de création de compte réussi
- [ ] Données visibles dans Table Editor

---

🎉 **Félicitations !** Tu sais maintenant accéder et utiliser ta base de données Supabase !

