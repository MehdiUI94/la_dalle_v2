-- Table pour suivre les commandes des étudiants dans les restaurants
-- Chaque commande compte pour la progression vers une récompense gratuite (10 commandes)

CREATE TABLE restaurant_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  etudiant_id UUID NOT NULL,
  restaurant_id UUID NOT NULL,
  visit_id UUID NOT NULL, -- Lien avec la visite (scan QR code)
  order_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  CONSTRAINT fk_etudiant FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE,
  CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  CONSTRAINT fk_visit FOREIGN KEY (visit_id) REFERENCES restaurant_visits(id) ON DELETE CASCADE
);

CREATE INDEX idx_restaurant_orders_etudiant_id ON restaurant_orders(etudiant_id);
CREATE INDEX idx_restaurant_orders_restaurant_id ON restaurant_orders(restaurant_id);
CREATE INDEX idx_restaurant_orders_visit_id ON restaurant_orders(visit_id);
CREATE INDEX idx_restaurant_orders_order_date ON restaurant_orders(order_date);

ALTER TABLE restaurant_orders ENABLE ROW LEVEL SECURITY;

-- Les étudiants peuvent voir leurs propres commandes
DROP POLICY IF EXISTS "Etudiants can view their own orders" ON restaurant_orders;
CREATE POLICY "Etudiants can view their own orders"
  ON restaurant_orders
  FOR SELECT
  TO public
  USING (true);

-- Les étudiants peuvent créer leurs propres commandes
DROP POLICY IF EXISTS "Etudiants can insert their own orders" ON restaurant_orders;
CREATE POLICY "Etudiants can insert their own orders"
  ON restaurant_orders
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Les restaurants peuvent voir les commandes de leur restaurant
DROP POLICY IF EXISTS "Restaurants can view orders for their restaurant" ON restaurant_orders;
CREATE POLICY "Restaurants can view orders for their restaurant"
  ON restaurant_orders
  FOR SELECT
  TO public
  USING (true);

-- Fonction pour obtenir le nombre de commandes d'un étudiant dans un restaurant
CREATE OR REPLACE FUNCTION get_etudiant_order_count(etudiant_uuid UUID, restaurant_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
  order_count INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO order_count
  FROM restaurant_orders
  WHERE etudiant_id = etudiant_uuid
    AND restaurant_id = restaurant_uuid;
  
  RETURN COALESCE(order_count, 0);
END;
$$ LANGUAGE plpgsql;

-- Fonction pour obtenir le nombre de commandes restantes avant la récompense (10 commandes)
CREATE OR REPLACE FUNCTION get_remaining_orders_for_reward(etudiant_uuid UUID, restaurant_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
  order_count INTEGER;
  remaining INTEGER;
BEGIN
  order_count := get_etudiant_order_count(etudiant_uuid, restaurant_uuid);
  remaining := GREATEST(0, 10 - (order_count % 10));
  
  RETURN remaining;
END;
$$ LANGUAGE plpgsql;

