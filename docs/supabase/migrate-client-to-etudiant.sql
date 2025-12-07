-- Migration : Renommer 'clients' en 'etudiants' et 'client_addresses' en 'etudiant_addresses'
-- Ce script renomme uniquement les noms de tables et colonnes, pas les données
-- IMPORTANT : Exécutez ce script dans l'ordre indiqué

-- Vérification préalable : s'assurer que les tables existent
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'clients') THEN
    RAISE EXCEPTION 'La table "clients" n''existe pas. Vérifiez que vous avez bien une base de données existante.';
  END IF;
END $$;

-- 1. Renommer la table clients en etudiants
ALTER TABLE clients RENAME TO etudiants;

-- 2. Renommer la table client_addresses en etudiant_addresses (si elle existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'client_addresses') THEN
    ALTER TABLE client_addresses RENAME TO etudiant_addresses;
  END IF;
END $$;

-- 3. Renommer la colonne client_id en etudiant_id dans etudiant_addresses (si la table existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'etudiant_addresses') THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'etudiant_addresses' AND column_name = 'client_id') THEN
      ALTER TABLE etudiant_addresses RENAME COLUMN client_id TO etudiant_id;
    END IF;
  END IF;
END $$;

-- 4. Renommer la colonne client_id en etudiant_id dans restaurant_ratings (si la table existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'restaurant_ratings') THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'restaurant_ratings' AND column_name = 'client_id') THEN
      ALTER TABLE restaurant_ratings RENAME COLUMN client_id TO etudiant_id;
    END IF;
  END IF;
END $$;

-- 5. Renommer la colonne client_id en etudiant_id dans restaurant_visits (si la table existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'restaurant_visits') THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'restaurant_visits' AND column_name = 'client_id') THEN
      ALTER TABLE restaurant_visits RENAME COLUMN client_id TO etudiant_id;
    END IF;
  END IF;
END $$;

-- 6. Renommer la colonne client_id en etudiant_id dans rating_notifications (si la table existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'rating_notifications') THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rating_notifications' AND column_name = 'client_id') THEN
      ALTER TABLE rating_notifications RENAME COLUMN client_id TO etudiant_id;
    END IF;
  END IF;
END $$;

-- 7. Renommer la colonne client_id en etudiant_id dans favorites (si elle existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'favorites') THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'favorites' AND column_name = 'client_id') THEN
      ALTER TABLE favorites RENAME COLUMN client_id TO etudiant_id;
    END IF;
  END IF;
END $$;

-- 8. Mettre à jour les contraintes de clés étrangères pour etudiant_addresses
DO $$
BEGIN
  -- Supprimer l'ancienne contrainte si elle existe
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'client_addresses_client_id_fkey' 
    AND table_name = 'etudiant_addresses'
  ) THEN
    ALTER TABLE etudiant_addresses DROP CONSTRAINT client_addresses_client_id_fkey;
  END IF;
  
  -- Ajouter la nouvelle contrainte si elle n'existe pas déjà
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'etudiant_addresses_etudiant_id_fkey' 
    AND table_name = 'etudiant_addresses'
  ) THEN
    ALTER TABLE etudiant_addresses ADD CONSTRAINT etudiant_addresses_etudiant_id_fkey 
      FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE;
  END IF;
END $$;

-- 9. Mettre à jour les contraintes pour restaurant_ratings
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'restaurant_ratings') THEN
    -- Supprimer l'ancienne contrainte si elle existe
    IF EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_client' 
      AND table_name = 'restaurant_ratings'
    ) THEN
      ALTER TABLE restaurant_ratings DROP CONSTRAINT fk_client;
    END IF;
    
    -- Ajouter la nouvelle contrainte si elle n'existe pas déjà
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_etudiant' 
      AND table_name = 'restaurant_ratings'
    ) THEN
      ALTER TABLE restaurant_ratings ADD CONSTRAINT fk_etudiant 
        FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE;
    END IF;
  END IF;
END $$;

-- 10. Mettre à jour les contraintes pour restaurant_visits
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'restaurant_visits') THEN
    -- Supprimer l'ancienne contrainte si elle existe
    IF EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_client' 
      AND table_name = 'restaurant_visits'
    ) THEN
      ALTER TABLE restaurant_visits DROP CONSTRAINT fk_client;
    END IF;
    
    -- Ajouter la nouvelle contrainte si elle n'existe pas déjà
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_etudiant' 
      AND table_name = 'restaurant_visits'
    ) THEN
      ALTER TABLE restaurant_visits ADD CONSTRAINT fk_etudiant 
        FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE;
    END IF;
  END IF;
END $$;

-- 11. Mettre à jour les contraintes pour rating_notifications
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'rating_notifications') THEN
    -- Supprimer l'ancienne contrainte si elle existe
    IF EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_client' 
      AND table_name = 'rating_notifications'
    ) THEN
      ALTER TABLE rating_notifications DROP CONSTRAINT fk_client;
    END IF;
    
    -- Ajouter la nouvelle contrainte si elle n'existe pas déjà
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.table_constraints 
      WHERE constraint_name = 'fk_etudiant' 
      AND table_name = 'rating_notifications'
    ) THEN
      ALTER TABLE rating_notifications ADD CONSTRAINT fk_etudiant 
        FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE;
    END IF;
  END IF;
END $$;

-- 12. Renommer les index
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_client_addresses_client_id') THEN
    ALTER INDEX idx_client_addresses_client_id RENAME TO idx_etudiant_addresses_etudiant_id;
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_restaurant_ratings_client_id') THEN
    ALTER INDEX idx_restaurant_ratings_client_id RENAME TO idx_restaurant_ratings_etudiant_id;
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_restaurant_visits_client_id') THEN
    ALTER INDEX idx_restaurant_visits_client_id RENAME TO idx_restaurant_visits_etudiant_id;
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_rating_notifications_client_id') THEN
    ALTER INDEX idx_rating_notifications_client_id RENAME TO idx_rating_notifications_etudiant_id;
  END IF;
END $$;

-- 13. Mettre à jour les politiques RLS (renommer les policies)
DO $$
BEGIN
  -- Policies pour etudiant_addresses
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'etudiant_addresses' AND policyname = 'Public can insert client addresses') THEN
    ALTER POLICY "Public can insert client addresses" ON etudiant_addresses RENAME TO "Public can insert etudiant addresses";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'etudiant_addresses' AND policyname = 'Public can select client addresses') THEN
    ALTER POLICY "Public can select client addresses" ON etudiant_addresses RENAME TO "Public can select etudiant addresses";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'etudiant_addresses' AND policyname = 'Public can update client addresses') THEN
    ALTER POLICY "Public can update client addresses" ON etudiant_addresses RENAME TO "Public can update etudiant addresses";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'etudiant_addresses' AND policyname = 'Public can delete client addresses') THEN
    ALTER POLICY "Public can delete client addresses" ON etudiant_addresses RENAME TO "Public can delete etudiant addresses";
  END IF;
  
  -- Policies pour restaurant_ratings
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_ratings' AND policyname = 'Clients can view all ratings') THEN
    ALTER POLICY "Clients can view all ratings" ON restaurant_ratings RENAME TO "Etudiants can view all ratings";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_ratings' AND policyname = 'Clients can insert their own ratings') THEN
    ALTER POLICY "Clients can insert their own ratings" ON restaurant_ratings RENAME TO "Etudiants can insert their own ratings";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_ratings' AND policyname = 'Clients can update their own ratings') THEN
    ALTER POLICY "Clients can update their own ratings" ON restaurant_ratings RENAME TO "Etudiants can update their own ratings";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_ratings' AND policyname = 'Clients can delete their own ratings') THEN
    ALTER POLICY "Clients can delete their own ratings" ON restaurant_ratings RENAME TO "Etudiants can delete their own ratings";
  END IF;
  
  -- Policies pour restaurant_visits
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_visits' AND policyname = 'Clients can view their own visits') THEN
    ALTER POLICY "Clients can view their own visits" ON restaurant_visits RENAME TO "Etudiants can view their own visits";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'restaurant_visits' AND policyname = 'Clients can insert their own visits') THEN
    ALTER POLICY "Clients can insert their own visits" ON restaurant_visits RENAME TO "Etudiants can insert their own visits";
  END IF;
  
  -- Policies pour rating_notifications
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'rating_notifications' AND policyname = 'Clients can view their own notifications') THEN
    ALTER POLICY "Clients can view their own notifications" ON rating_notifications RENAME TO "Etudiants can view their own notifications";
  END IF;
  
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'rating_notifications' AND policyname = 'Clients can update their own notifications') THEN
    ALTER POLICY "Clients can update their own notifications" ON rating_notifications RENAME TO "Etudiants can update their own notifications";
  END IF;
END $$;

-- 14. Mettre à jour les fonctions qui référencent client_id
CREATE OR REPLACE FUNCTION create_rating_notification()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO rating_notifications (etudiant_id, restaurant_id, visit_id, notification_type)
  VALUES (NEW.etudiant_id, NEW.restaurant_id, NEW.id, 'first_visit');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Message de confirmation
DO $$
BEGIN
  RAISE NOTICE 'Migration terminée avec succès ! Les tables "clients" et "client_addresses" ont été renommées en "etudiants" et "etudiant_addresses".';
END $$;
