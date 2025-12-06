INSERT INTO storage.buckets (id, name, public)
VALUES ('images', 'images', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Allow public read images"
ON storage.objects FOR SELECT
USING (bucket_id = 'images');

CREATE POLICY "Allow public upload images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'images');

CREATE POLICY "Allow public update images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'images');

CREATE POLICY "Allow public delete images"
ON storage.objects FOR DELETE
USING (bucket_id = 'images');

