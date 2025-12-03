# Quick Start : Supabase en 5 minutes ⚡

## 🚀 Guide ultra-rapide

### 1️⃣ Créer le projet (2 min)

1. Aller sur [supabase.com](https://supabase.com) → **Start your project**
2. S'inscrire (GitHub ou email)
3. **New Project** → Nom : `la-dalle` → Créer
4. ⏳ Attendre 2-3 minutes

### 2️⃣ Créer les tables (1 min)

1. Menu gauche → **SQL Editor**
2. Ouvrir `docs/supabase/schema.sql` dans ton projet
3. **Copier TOUT** → **Coller** dans SQL Editor
4. **Run** (▶️) ou **Ctrl+Enter**
5. ✅ Succès !

### 3️⃣ Récupérer les clés (1 min)

1. Menu gauche → **Settings** → **API**
2. Copier **Project URL** et **anon public key**
3. Créer fichier `.env` à la racine :

```env
VITE_SUPABASE_URL=ton-url-ici
VITE_SUPABASE_ANON_KEY=ta-clé-ici
```

### 4️⃣ Tester (1 min)

1. Redémarrer : `npm run dev`
2. Aller sur `/login`
3. Créer un compte test
4. Vérifier dans **Table Editor** → **profiles** → Tu vois ton compte ! 🎉

---

## 📍 Où trouver quoi ?

| Ce que tu cherches | Où aller |
|-------------------|----------|
| Voir les données | **Table Editor** |
| Exécuter du SQL | **SQL Editor** |
| Gérer les utilisateurs | **Authentication** |
| Les clés API | **Settings** → **API** |
| Modifier le projet | **Settings** → **General** |

---

## 🎯 Commandes SQL utiles

```sql
-- Voir tous les profils
SELECT * FROM profiles;

-- Voir tous les restaurants
SELECT * FROM restaurants;

-- Voir tous les deals actifs
SELECT * FROM deals WHERE is_active = true;

-- Compter les clients
SELECT COUNT(*) FROM clients;

-- Voir les restaurants d'un arrondissement
SELECT * FROM restaurants WHERE arrondissement = '11ème';
```

---

**Besoin d'aide ?** Voir `docs/supabase/guide-debutant.md` pour le guide complet ! 📚

