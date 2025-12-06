# Correction de l'erreur RLS lors de l'inscription

## Problèmes

1. Erreur RLS : `new row violates row-level security policy for table "profiles"`
2. Erreur contrainte de clé étrangère : `insert or update on table "profiles" violates foreign key constraint "profiles_id_fkey"`

## Solution

Exécutez le script SQL `fix-rls-profiles-signup-clean.sql` dans l'éditeur SQL de Supabase.

### Étapes

1. Ouvrez votre projet Supabase
2. Allez dans SQL Editor
3. Créez une nouvelle requête
4. Copiez-collez le contenu de `docs/supabase/fix-rls-profiles-signup-clean.sql`
5. Exécutez la requête

## Vérification

```sql
SELECT conname, contype 
FROM pg_constraint 
WHERE conrelid = 'public.profiles'::regclass 
AND conname = 'profiles_id_fkey';
```

```sql
SELECT * FROM pg_policies WHERE tablename = 'profiles';
```

```sql
SELECT tablename, rowsecurity FROM pg_tables WHERE tablename = 'profiles';
```

