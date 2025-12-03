# Guide d'installation Supabase pour LA DALLE

## Étape 1 : Créer le projet Supabase

1. Aller sur [https://app.supabase.com](https://app.supabase.com)
2. Cliquer sur "New project"
3. Choisir :
   - Organization (ou créer une nouvelle)
   - Nom du projet : `la-dalle`
   - Database password (IMPORTANT : sauvegarder ce mot de passe)
   - Region : `Europe West (Frankfurt)` ou la plus proche de Paris
4. Cliquer sur "Create new project"

## Étape 2 : Récupérer les clés API

1. Dans le dashboard Supabase, aller dans **Settings** → **API**
2. Copier :
   - **Project URL** (exemple : `https://xxxxx.supabase.co`)
   - **anon/public key** (commence par `eyJhbGc...`)

3. Créer le fichier `.env` à la racine du projet :

```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...
```

## Étape 3 : Créer les tables

1. Dans le dashboard Supabase, aller dans **SQL Editor**
2. Cliquer sur "New query"
3. Copier-coller le contenu de `docs/supabase/schema.sql`
4. Cliquer sur "Run" (▶️)

Vérifier que toutes les tables sont créées :
- profiles
- clients
- restaurants
- deals
- favorites

## Étape 4 : Configurer l'authentification

1. Aller dans **Authentication** → **Providers**
2. Activer **Email** (déjà activé par défaut)
3. Optionnel : activer d'autres providers (Google, etc.)

### Configuration Email

Par défaut, Supabase demande une confirmation d'email. Pour le développement, vous pouvez la désactiver :

1. **Authentication** → **Settings**
2. Désactiver "Enable email confirmations"

⚠️ **Important** : Réactiver cette option en production !

## Étape 5 : Configuration des URL de redirection

1. **Authentication** → **URL Configuration**
2. Ajouter les URLs autorisées :
   - `http://localhost:5173` (développement)
   - Votre URL de production quand elle sera disponible

## Étape 6 : Créer des données de test (optionnel)

Pour tester l'application avec des données, exécuter dans SQL Editor :

```sql
-- Insérer un restaurant de test
insert into public.profiles (id, role, display_name)
values ('550e8400-e29b-41d4-a716-446655440000', 'restaurant', 'Pizza Test');

insert into public.restaurants (id, name, description, address, arrondissement, lat, lng)
values (
  '550e8400-e29b-41d4-a716-446655440000',
  'Pizza Paradise Test',
  'Restaurant de test pour développement',
  '123 rue de Test, 75011 Paris',
  '11ème',
  48.8566,
  2.3522
);

-- Insérer un deal de test
insert into public.deals (restaurant_id, title, description, category, deal_type)
values (
  '550e8400-e29b-41d4-a716-446655440000',
  '1 Pizza = 1 Pizza offerte',
  'Deal de test',
  'pizza',
  '1+1'
);
```

## Étape 7 : Vérifier l'installation

Lancer l'application :

```bash
npm run dev
```

Tester :
1. Créer un compte client
2. Se connecter
3. Vérifier dans Supabase → **Table Editor** que les données sont bien créées

## Dépannage

### Erreur : "Invalid API key"
→ Vérifier que `.env` contient les bonnes clés et relancer `npm run dev`

### Erreur : "relation does not exist"
→ Les tables n'ont pas été créées. Réexécuter `schema.sql`

### Erreur : "row level security policy violation"
→ Vérifier que les policies RLS sont bien créées dans `schema.sql`

## Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Guide Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Discord](https://discord.supabase.com) pour le support

