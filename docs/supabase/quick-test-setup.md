# 🚀 Configuration rapide des utilisateurs de test

## Méthode la plus simple (recommandée)

### 1. Créer un compte CLIENT via l'app

1. Va sur `http://localhost:5173/login`
2. Clique sur **"Pas encore de compte ? S'inscrire"**
3. Remplis :
   - **Email** : `client@test.com`
   - **Password** : `test123456`
   - **Sélectionne** : 👤 **Client**
4. Clique sur **"Créer mon compte"**
5. Complète l'onboarding client

✅ **Résultat** : Un profil client est créé automatiquement dans Supabase !

### 2. Créer un compte RESTAURANT via l'app

1. Va sur `http://localhost:5173/login`
2. Clique sur **"Pas encore de compte ? S'inscrire"**
3. Remplis :
   - **Email** : `resto@test.com`
   - **Password** : `test123456`
   - **Sélectionne** : 🍕 **Restaurant**
4. Clique sur **"Créer mon compte"**
5. Complète l'onboarding restaurant

✅ **Résultat** : Un profil restaurant est créé automatiquement dans Supabase !

### 3. Vérifier dans Supabase

1. Va sur [app.supabase.com](https://app.supabase.com)
2. **Table Editor** → **profiles** → Tu vois tes 2 comptes
3. **Table Editor** → **clients** → Tu vois le profil client
4. **Table Editor** → **restaurants** → Tu vois le profil restaurant

---

## Utiliser les comptes de test

### Connexion CLIENT
- Email : `client@test.com`
- Password : `test123456`

### Connexion RESTAURANT
- Email : `resto@test.com`
- Password : `test123456`

---

## Alternative : Créer via SQL (avancé)

Si tu veux créer les profils directement en SQL, voir `create-test-users.sql`

⚠️ **Note** : Tu dois d'abord créer les utilisateurs dans `auth.users` via l'app ou l'API Auth.

