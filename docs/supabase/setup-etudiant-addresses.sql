CREATE TABLE IF NOT EXISTS etudiant_addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  etudiant_id UUID NOT NULL REFERENCES etudiants(id) ON DELETE CASCADE,
  address TEXT NOT NULL,
  lat NUMERIC(10, 8),
  lng NUMERIC(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  label TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_etudiant_addresses_etudiant_id ON etudiant_addresses(etudiant_id);
CREATE INDEX IF NOT EXISTS idx_etudiant_addresses_is_default ON etudiant_addresses(is_default);

ALTER TABLE etudiant_addresses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can insert etudiant addresses" ON etudiant_addresses;
CREATE POLICY "Public can insert etudiant addresses" ON etudiant_addresses
  FOR INSERT
  TO public
  WITH CHECK (true);

DROP POLICY IF EXISTS "Public can select etudiant addresses" ON etudiant_addresses;
CREATE POLICY "Public can select etudiant addresses" ON etudiant_addresses
  FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Public can update etudiant addresses" ON etudiant_addresses;
CREATE POLICY "Public can update etudiant addresses" ON etudiant_addresses
  FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Public can delete etudiant addresses" ON etudiant_addresses;
CREATE POLICY "Public can delete etudiant addresses" ON etudiant_addresses
  FOR DELETE
  TO public
  USING (true);

UPDATE etudiants
SET address = '10 Rue de la Paix, 75002 Paris'
WHERE email = 'client@test.com';

INSERT INTO etudiant_addresses (etudiant_id, address, lat, lng, is_default, label)
SELECT 
  id,
  '10 Rue de la Paix, 75002 Paris',
  48.8698,
  2.3314,
  TRUE,
  'Adresse par défaut'
FROM etudiants
WHERE email = 'client@test.com'
ON CONFLICT DO NOTHING;

