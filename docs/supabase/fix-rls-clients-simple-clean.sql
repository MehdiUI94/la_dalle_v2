ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'clients') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.clients';
    END LOOP;
END $$;

CREATE POLICY "clients_allow_public_insert"
ON public.clients
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "clients_allow_public_select"
ON public.clients
FOR SELECT
TO public
USING (true);

CREATE POLICY "clients_allow_public_update"
ON public.clients
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'clients';

