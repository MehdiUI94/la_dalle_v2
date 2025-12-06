DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM pg_constraint 
    WHERE conname = 'profiles_id_fkey' 
    AND conrelid = 'public.profiles'::regclass
  ) THEN
    ALTER TABLE public.profiles DROP CONSTRAINT profiles_id_fkey;
  END IF;
END $$;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'profiles') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.profiles';
    END LOOP;
END $$;

CREATE POLICY "profiles_allow_public_insert"
ON public.profiles
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "profiles_allow_public_select"
ON public.profiles
FOR SELECT
TO public
USING (true);

CREATE POLICY "profiles_allow_public_update"
ON public.profiles
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

