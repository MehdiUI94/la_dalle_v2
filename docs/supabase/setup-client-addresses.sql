CREATE TABLE IF NOT EXISTS client_addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  address TEXT NOT NULL,
  lat NUMERIC(10, 8),
  lng NUMERIC(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  label TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_client_addresses_client_id ON client_addresses(client_id);
CREATE INDEX IF NOT EXISTS idx_client_addresses_is_default ON client_addresses(is_default);

ALTER TABLE client_addresses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can insert client addresses" ON client_addresses;
CREATE POLICY "Public can insert client addresses" ON client_addresses
  FOR INSERT
  TO public
  WITH CHECK (true);

DROP POLICY IF EXISTS "Public can select client addresses" ON client_addresses;
CREATE POLICY "Public can select client addresses" ON client_addresses
  FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Public can update client addresses" ON client_addresses;
CREATE POLICY "Public can update client addresses" ON client_addresses
  FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

DROP POLICY IF EXISTS "Public can delete client addresses" ON client_addresses;
CREATE POLICY "Public can delete client addresses" ON client_addresses
  FOR DELETE
  TO public
  USING (true);

UPDATE clients
SET address = '10 Rue de la Paix, 75002 Paris'
WHERE email = 'client@test.com';

INSERT INTO client_addresses (client_id, address, lat, lng, is_default, label)
SELECT 
  id,
  '10 Rue de la Paix, 75002 Paris',
  48.8698,
  2.3314,
  TRUE,
  'Adresse par défaut'
FROM clients
WHERE email = 'client@test.com'
ON CONFLICT DO NOTHING;

