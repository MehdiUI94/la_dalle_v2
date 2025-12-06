# Correction de l'erreur RLS sur clients et restaurants

## Problème

Lors de l'inscription, vous obtenez l'erreur :
```
new row violates row-level security policy for table "clients"
```

Ou similaire pour la table `restaurants`.

## Cause

Les tables `clients` et `restaurants` ont RLS (Row Level Security) activé, mais il n'y a pas de politiques permettant l'insertion publique lors de l'inscription.

## Solution

Exécutez le script SQL `fix-rls-clients-restaurants.sql` dans l'éditeur SQL de Supabase.

### Étapes

1. Ouvrez votre projet Supabase
2. Allez dans **SQL Editor**
3. Créez une nouvelle requête
4. Copiez-collez le contenu de `docs/supabase/fix-rls-clients-restaurants.sql`
5. Exécutez la requête

### Ce que fait le script

Pour les tables `clients` et `restaurants` :
- Active RLS sur les tables (si ce n'est pas déjà fait)
- Supprime les anciennes politiques pour éviter les conflits
- Crée une politique permettant l'insertion publique (nécessaire pour l'inscription)
- Crée une politique permettant la lecture publique (pour afficher les informations)
- Crée une politique permettant la mise à jour (vous pouvez restreindre plus tard)

## Vérification

Après avoir exécuté le script, le script affichera automatiquement toutes les politiques créées.

Vous pouvez aussi vérifier manuellement :
```sql
SELECT * FROM pg_policies WHERE tablename IN ('clients', 'restaurants');
```

## Sécurité

⚠️ **Note importante** : Ces politiques permettent l'insertion publique. C'est nécessaire pour l'inscription, mais assurez-vous que :
- La validation des données est faite côté serveur (via des triggers ou fonctions)
- Les champs sensibles (comme les mots de passe) sont protégés
- Vous avez d'autres mécanismes de sécurité en place

## Scripts à exécuter

### Option 1 : Script combiné (RECOMMANDÉ)

Pour corriger tous les problèmes d'inscription en une seule fois, exécutez :
- **`fix-signup-complete.sql`** : Script complet qui corrige tout (colonnes manquantes + RLS + contrainte FK)

### Option 2 : Scripts séparés

Si vous préférez exécuter les scripts séparément, exécutez-les dans l'ordre :

1. **`add-missing-columns.sql`** : Ajoute les colonnes manquantes
2. **`fix-rls-profiles-signup.sql`** : Corrige RLS sur `profiles` et supprime la contrainte FK
3. **`fix-rls-clients-restaurants.sql`** : Corrige RLS sur `clients` et `restaurants` (ce script)

Après avoir exécuté le script combiné ou les trois scripts séparés, l'inscription devrait fonctionner correctement.

