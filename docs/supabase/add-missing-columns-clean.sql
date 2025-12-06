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

SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('clients', 'restaurants')
ORDER BY table_name, ordinal_position;

