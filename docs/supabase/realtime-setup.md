# Configuration Supabase Realtime pour la carte

## Étapes pour activer les mises à jour en temps réel

### 1. Activer Realtime dans Supabase Dashboard

1. Allez dans votre projet Supabase
2. Cliquez sur **Database** dans le menu latéral
3. Cliquez sur **Replication** (ou **Publications**)
4. Vérifiez que `supabase_realtime` est activé

### 2. Exécuter le script SQL

Exécutez le script `enable-realtime.sql` dans l'éditeur SQL de Supabase :

```sql
-- Activer Realtime sur la table restaurants
ALTER PUBLICATION supabase_realtime ADD TABLE public.restaurants;

-- Activer Realtime sur la table deals
ALTER PUBLICATION supabase_realtime ADD TABLE public.deals;
```

### 3. Vérifier les permissions RLS

Assurez-vous que les politiques RLS permettent la lecture des données :

```sql
-- Vérifier que les utilisateurs peuvent lire les restaurants
SELECT * FROM pg_policies WHERE tablename = 'restaurants';

-- Si nécessaire, créer une politique pour permettre la lecture publique
CREATE POLICY "Allow public read access to restaurants"
ON public.restaurants
FOR SELECT
USING (true);
```

### 4. Tester la connexion

Une fois configuré, la carte devrait :
- Afficher un indicateur "Mise à jour en temps réel activée" (point vert)
- Mettre à jour automatiquement quand un restaurant est ajouté/modifié/supprimé
- Mettre à jour automatiquement quand un deal change

## Dépannage

### Le statut reste "Connexion en cours..."
- Vérifiez que Realtime est activé dans Supabase Dashboard
- Vérifiez que les tables sont dans la publication `supabase_realtime`
- Vérifiez la console du navigateur pour les erreurs

### Les mises à jour ne fonctionnent pas
- Vérifiez que RLS permet la lecture des données
- Vérifiez que les événements sont bien émis (console du navigateur)
- Vérifiez que les coordonnées (lat/lng) sont bien renseignées



