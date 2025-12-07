CREATE TABLE restaurant_visits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  etudiant_id UUID NOT NULL,
  restaurant_id UUID NOT NULL,
  scanned_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  qr_code_data TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  CONSTRAINT fk_etudiant FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE,
  CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  UNIQUE(etudiant_id, restaurant_id, DATE(scanned_at))
);

CREATE INDEX idx_restaurant_visits_etudiant_id ON restaurant_visits(etudiant_id);
CREATE INDEX idx_restaurant_visits_restaurant_id ON restaurant_visits(restaurant_id);
CREATE INDEX idx_restaurant_visits_scanned_at ON restaurant_visits(scanned_at);

ALTER TABLE restaurant_visits ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Etudiants can view their own visits" ON restaurant_visits;
CREATE POLICY "Etudiants can view their own visits"
  ON restaurant_visits
  FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Etudiants can insert their own visits" ON restaurant_visits;
CREATE POLICY "Etudiants can insert their own visits"
  ON restaurant_visits
  FOR INSERT
  TO public
  WITH CHECK (true);

DROP POLICY IF EXISTS "Restaurants can view visits to their restaurant" ON restaurant_visits;
CREATE POLICY "Restaurants can view visits to their restaurant"
  ON restaurant_visits
  FOR SELECT
  TO public
  USING (true);

CREATE TABLE rating_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  etudiant_id UUID NOT NULL,
  restaurant_id UUID NOT NULL,
  visit_id UUID NOT NULL,
  notification_sent_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  notification_type VARCHAR(50) NOT NULL DEFAULT 'first_visit',
  is_read BOOLEAN DEFAULT FALSE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  CONSTRAINT fk_etudiant FOREIGN KEY (etudiant_id) REFERENCES etudiants(id) ON DELETE CASCADE,
  CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  CONSTRAINT fk_visit FOREIGN KEY (visit_id) REFERENCES restaurant_visits(id) ON DELETE CASCADE
);

CREATE INDEX idx_rating_notifications_etudiant_id ON rating_notifications(etudiant_id);
CREATE INDEX idx_rating_notifications_restaurant_id ON rating_notifications(restaurant_id);
CREATE INDEX idx_rating_notifications_is_read ON rating_notifications(is_read);

ALTER TABLE rating_notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Etudiants can view their own notifications" ON rating_notifications;
CREATE POLICY "Etudiants can view their own notifications"
  ON rating_notifications
  FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Etudiants can update their own notifications" ON rating_notifications;
CREATE POLICY "Etudiants can update their own notifications"
  ON rating_notifications
  FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE OR REPLACE FUNCTION create_rating_notification()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO rating_notifications (etudiant_id, restaurant_id, visit_id, notification_type)
  VALUES (NEW.etudiant_id, NEW.restaurant_id, NEW.id, 'first_visit');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_create_rating_notification ON restaurant_visits;
CREATE TRIGGER trigger_create_rating_notification
  AFTER INSERT ON restaurant_visits
  FOR EACH ROW
  EXECUTE FUNCTION create_rating_notification();
