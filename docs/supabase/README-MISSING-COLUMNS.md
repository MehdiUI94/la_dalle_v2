# Correction des colonnes manquantes

## Problème

Vous obtenez l'erreur :
```
Could not find the 'address' column of 'clients' in the schema cache
```

Ou d'autres erreurs similaires pour d'autres colonnes.

## Cause

Les colonnes nécessaires n'ont pas été créées dans les tables `clients` et `restaurants` de votre base de données Supabase.

## Solution

Exécutez le script SQL `add-missing-columns.sql` dans l'éditeur SQL de Supabase.

### Étapes

1. Ouvrez votre projet Supabase
2. Allez dans **SQL Editor**
3. Créez une nouvelle requête
4. Copiez-collez le contenu de `docs/supabase/add-missing-columns.sql`
5. Exécutez la requête

### Ce que fait le script

Le script vérifie et ajoute toutes les colonnes manquantes dans les tables `clients` et `restaurants` :

**Table `clients`** :
- `address` (TEXT)
- `firstname` (TEXT)
- `lastname` (TEXT)
- `age` (INTEGER)
- `phone` (TEXT)
- `ine` (TEXT, UNIQUE)
- `is_student` (BOOLEAN, DEFAULT TRUE, NOT NULL)
- `notifications_email` (BOOLEAN, DEFAULT FALSE)
- `notifications_phone` (BOOLEAN, DEFAULT FALSE)

**Table `restaurants`** :
- `address` (TEXT)
- `owner_firstname` (TEXT)
- `owner_lastname` (TEXT)
- `description` (TEXT)
- `logo` (TEXT)
- `siren` (TEXT)
- `siret` (TEXT)
- `social_media` (TEXT)
- `phone` (TEXT)
- `notifications_email` (BOOLEAN, DEFAULT FALSE)
- `notifications_phone` (BOOLEAN, DEFAULT FALSE)

## Vérification

Après avoir exécuté le script, le script affichera automatiquement toutes les colonnes des tables `clients` et `restaurants` pour vérification.

Vous pouvez aussi vérifier manuellement :
```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('clients', 'restaurants')
ORDER BY table_name, ordinal_position;
```

## Notes

- Le script est idempotent : vous pouvez l'exécuter plusieurs fois sans problème
- Il ne supprime pas de colonnes existantes
- Il ajoute uniquement les colonnes manquantes
- Les colonnes sont créées avec les types appropriés selon le schéma TypeScript

