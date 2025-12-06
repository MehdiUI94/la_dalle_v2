DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'address') THEN
    ALTER TABLE public.clients ADD COLUMN address TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'firstname') THEN
    ALTER TABLE public.clients ADD COLUMN firstname TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'lastname') THEN
    ALTER TABLE public.clients ADD COLUMN lastname TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'age') THEN
    ALTER TABLE public.clients ADD COLUMN age INTEGER;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'phone') THEN
    ALTER TABLE public.clients ADD COLUMN phone TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'ine') THEN
    ALTER TABLE public.clients ADD COLUMN ine TEXT UNIQUE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'is_student') THEN
    ALTER TABLE public.clients ADD COLUMN is_student BOOLEAN DEFAULT TRUE NOT NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'notifications_email') THEN
    ALTER TABLE public.clients ADD COLUMN notifications_email BOOLEAN DEFAULT FALSE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'notifications_phone') THEN
    ALTER TABLE public.clients ADD COLUMN notifications_phone BOOLEAN DEFAULT FALSE;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'address') THEN
    ALTER TABLE public.restaurants ADD COLUMN address TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'owner_firstname') THEN
    ALTER TABLE public.restaurants ADD COLUMN owner_firstname TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'owner_lastname') THEN
    ALTER TABLE public.restaurants ADD COLUMN owner_lastname TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'description') THEN
    ALTER TABLE public.restaurants ADD COLUMN description TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'logo') THEN
    ALTER TABLE public.restaurants ADD COLUMN logo TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'siren') THEN
    ALTER TABLE public.restaurants ADD COLUMN siren TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'siret') THEN
    ALTER TABLE public.restaurants ADD COLUMN siret TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'social_media') THEN
    ALTER TABLE public.restaurants ADD COLUMN social_media TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'phone') THEN
    ALTER TABLE public.restaurants ADD COLUMN phone TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'notifications_email') THEN
    ALTER TABLE public.restaurants ADD COLUMN notifications_email BOOLEAN DEFAULT FALSE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'restaurants' AND column_name = 'notifications_phone') THEN
    ALTER TABLE public.restaurants ADD COLUMN notifications_phone BOOLEAN DEFAULT FALSE;
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
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

ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'restaurants') LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON public.restaurants';
    END LOOP;
END $$;

CREATE POLICY "restaurants_allow_public_insert"
ON public.restaurants
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "restaurants_allow_public_select"
ON public.restaurants
FOR SELECT
TO public
USING (true);

CREATE POLICY "restaurants_allow_public_update"
ON public.restaurants
FOR UPDATE
TO public
USING (true)
WITH CHECK (true);

SELECT tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename IN ('profiles', 'clients', 'restaurants')
ORDER BY tablename, policyname;

