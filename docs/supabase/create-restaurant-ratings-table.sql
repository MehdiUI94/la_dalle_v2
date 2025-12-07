CREATE TABLE restaurant_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  etudiant_id UUID NOT NULL,
  restaurant_id UUID NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(etudiant_id, restaurant_id)
);

ALTER TABLE restaurant_ratings 
  ADD CONSTRAINT fk_etudiant 
  FOREIGN KEY (etudiant_id) 
  REFERENCES etudiants(id) 
  ON DELETE CASCADE;

ALTER TABLE restaurant_ratings 
  ADD CONSTRAINT fk_restaurant 
  FOREIGN KEY (restaurant_id) 
  REFERENCES restaurants(id) 
  ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_restaurant_ratings_restaurant_id ON restaurant_ratings(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_restaurant_ratings_etudiant_id ON restaurant_ratings(etudiant_id);

ALTER TABLE restaurant_ratings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Etudiants can view all ratings" ON restaurant_ratings;
CREATE POLICY "Etudiants can view all ratings"
  ON restaurant_ratings
  FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Etudiants can insert their own ratings" ON restaurant_ratings;
CREATE POLICY "Etudiants can insert their own ratings"
  ON restaurant_ratings
  FOR INSERT
  TO public
  WITH CHECK (true);

DROP POLICY IF EXISTS "Etudiants can update their own ratings" ON restaurant_ratings;
CREATE POLICY "Etudiants can update their own ratings"
  ON restaurant_ratings
  FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Etudiants can delete their own ratings" ON restaurant_ratings;
CREATE POLICY "Etudiants can delete their own ratings"
  ON restaurant_ratings
  FOR DELETE
  TO public
  USING (true);

CREATE OR REPLACE FUNCTION update_restaurant_ratings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_restaurant_ratings_updated_at ON restaurant_ratings;
CREATE TRIGGER trigger_update_restaurant_ratings_updated_at
  BEFORE UPDATE ON restaurant_ratings
  FOR EACH ROW
  EXECUTE FUNCTION update_restaurant_ratings_updated_at();

CREATE OR REPLACE FUNCTION calculate_restaurant_average_rating(restaurant_uuid UUID)
RETURNS NUMERIC AS $$
DECLARE
  avg_rating NUMERIC;
BEGIN
  SELECT COALESCE(ROUND(AVG(rating)::NUMERIC, 1), 0)
  INTO avg_rating
  FROM restaurant_ratings
  WHERE restaurant_id = restaurant_uuid;
  
  RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;
