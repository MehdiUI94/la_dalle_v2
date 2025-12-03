-- ============================================================================
-- RECRÉER TOUTES LES TABLES AVEC LES BONS CHAMPS ET DONNÉES DE TEST
-- ============================================================================
-- 
-- Ce script :
-- 1. Supprime les tables existantes (dans le bon ordre)
-- 2. Recrée toutes les tables avec les bons champs
-- 3. Ajoute email et password aux tables clients et restaurants
-- 4. Insère des données de test
-- 
-- INSTRUCTIONS :
-- 1. Exécute ce script dans SQL Editor de Supabase
-- 2. Toutes les tables seront recréées avec des données de test
-- ============================================================================

-- ============================================================================
-- ÉTAPE 1 : SUPPRIMER LES TABLES EXISTANTES (dans le bon ordre)
-- ============================================================================

DROP TABLE IF EXISTS public.favorites CASCADE;
DROP TABLE IF EXISTS public.deals CASCADE;
DROP TABLE IF EXISTS public.clients CASCADE;
DROP TABLE IF EXISTS public.restaurants CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Supprimer les fonctions et triggers
DROP FUNCTION IF EXISTS public.handle_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.get_user_role(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.get_restaurant_deals(uuid) CASCADE;

-- ============================================================================
-- ÉTAPE 2 : CRÉER LES TABLES
-- ============================================================================

-- 1. Table PROFILES (profil de base pour tous les utilisateurs)
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('client', 'restaurant')),
  display_name text,
  avatar_url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- 2. Table CLIENTS (avec email et password)
CREATE TABLE public.clients (
  id uuid PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
  age int,
  is_student boolean DEFAULT false,
  school_name text,
  main_arrondissement text,
  budget_range text CHECK (budget_range IN ('€', '€€', '€€€')),
  favorite_categories text[],
  email text,
  password text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- 3. Table RESTAURANTS (avec email et password)
CREATE TABLE public.restaurants (
  id uuid PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  address text,
  arrondissement text,
  lat double precision,
  lng double precision,
  phone text,
  website text,
  instagram text,
  price_level text CHECK (price_level IN ('€', '€€', '€€€')),
  cuisine_types text[],
  is_student_friendly boolean DEFAULT true,
  max_deals_per_day int DEFAULT 50,
  image_url text,
  email text,
  password text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- 4. Table DEALS
CREATE TABLE public.deals (
  id bigserial PRIMARY KEY,
  restaurant_id uuid REFERENCES public.restaurants(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  deal_type text DEFAULT '1+1',
  category text,
  min_group_size int DEFAULT 2,
  max_group_size int,
  valid_from date,
  valid_to date,
  days_of_week text[],
  start_time time,
  end_time time,
  is_active boolean DEFAULT true,
  badge text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- 5. Table FAVORITES
CREATE TABLE public.favorites (
  id bigserial PRIMARY KEY,
  client_id uuid REFERENCES public.clients(id) ON DELETE CASCADE,
  deal_id bigint REFERENCES public.deals(id) ON DELETE CASCADE,
  created_at timestamp with time zone DEFAULT now(),
  UNIQUE(client_id, deal_id)
);

-- ============================================================================
-- ÉTAPE 3 : CRÉER LES POLICIES RLS (Row Level Security)
-- ============================================================================

-- RLS pour profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les profils sont visibles par tous"
  ON public.profiles FOR SELECT
  USING (true);

CREATE POLICY "Les utilisateurs peuvent mettre à jour leur propre profil"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Les utilisateurs peuvent créer leur profil"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- RLS pour clients
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les clients sont visibles par tous"
  ON public.clients FOR SELECT
  USING (true);

CREATE POLICY "Les clients peuvent mettre à jour leur propre profil"
  ON public.clients FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Les clients peuvent créer leur profil"
  ON public.clients FOR INSERT
  WITH CHECK (auth.uid() = id);

-- RLS pour restaurants
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les restaurants sont visibles par tous"
  ON public.restaurants FOR SELECT
  USING (true);

CREATE POLICY "Les restaurants peuvent mettre à jour leur propre profil"
  ON public.restaurants FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Les restaurants peuvent créer leur profil"
  ON public.restaurants FOR INSERT
  WITH CHECK (auth.uid() = id);

-- RLS pour deals
ALTER TABLE public.deals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les deals sont visibles par tous"
  ON public.deals FOR SELECT
  USING (is_active = true);

CREATE POLICY "Les restaurants peuvent créer leurs deals"
  ON public.deals FOR INSERT
  WITH CHECK (auth.uid() = restaurant_id);

CREATE POLICY "Les restaurants peuvent mettre à jour leurs deals"
  ON public.deals FOR UPDATE
  USING (auth.uid() = restaurant_id);

CREATE POLICY "Les restaurants peuvent supprimer leurs deals"
  ON public.deals FOR DELETE
  USING (auth.uid() = restaurant_id);

-- RLS pour favorites
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Les clients peuvent voir leurs favoris"
  ON public.favorites FOR SELECT
  USING (auth.uid() = client_id);

CREATE POLICY "Les clients peuvent ajouter des favoris"
  ON public.favorites FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Les clients peuvent supprimer leurs favoris"
  ON public.favorites FOR DELETE
  USING (auth.uid() = client_id);

-- ============================================================================
-- ÉTAPE 4 : CRÉER LES TRIGGERS ET FONCTIONS
-- ============================================================================

-- Fonction pour updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers pour updated_at
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.clients
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.restaurants
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.deals
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Fonctions utilitaires
CREATE OR REPLACE FUNCTION public.get_user_role(user_id uuid)
RETURNS text AS $$
  SELECT role FROM public.profiles WHERE id = user_id;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_restaurant_deals(resto_id uuid)
RETURNS SETOF public.deals AS $$
  SELECT * FROM public.deals WHERE restaurant_id = resto_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================================
-- ÉTAPE 5 : CRÉER LES INDEXES
-- ============================================================================

CREATE INDEX idx_deals_restaurant_id ON public.deals(restaurant_id);
CREATE INDEX idx_deals_is_active ON public.deals(is_active);
CREATE INDEX idx_deals_category ON public.deals(category);
CREATE INDEX idx_restaurants_arrondissement ON public.restaurants(arrondissement);
CREATE INDEX idx_favorites_client_id ON public.favorites(client_id);
CREATE INDEX idx_favorites_deal_id ON public.favorites(deal_id);

-- ============================================================================
-- ÉTAPE 6 : CRÉER LES UTILISATEURS AUTH ET INSÉRER LES DONNÉES DE TEST
-- ============================================================================

DO $$
DECLARE
  client_uuid UUID;
  restaurant_uuid UUID;
BEGIN

  -- Vérifier si l'utilisateur CLIENT existe déjà
  SELECT id INTO client_uuid FROM auth.users WHERE email = 'client@test.com';
  
  -- Si l'utilisateur n'existe pas, le créer
  IF client_uuid IS NULL THEN
    client_uuid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    )
    VALUES (
      client_uuid,
      '00000000-0000-0000-0000-000000000000',
      'client@test.com',
      crypt('test123456', gen_salt('bf')),
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      jsonb_build_object('role', 'client'),
      false,
      'authenticated',
      'authenticated'
    );
  ELSE
    -- Mettre à jour le mot de passe si l'utilisateur existe déjà
    UPDATE auth.users
    SET encrypted_password = crypt('test123456', gen_salt('bf')),
        email_confirmed_at = now(),
        updated_at = now()
    WHERE id = client_uuid;
  END IF;

  -- Créer le profil CLIENT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (client_uuid, 'client', 'Client Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  -- Créer les données CLIENT avec email et password
  INSERT INTO public.clients (
    id, age, is_student, school_name, main_arrondissement,
    budget_range, favorite_categories, email, password,
    created_at, updated_at
  )
  VALUES (
    client_uuid,
    22,
    true,
    'Sorbonne',
    '11ème',
    '€€',
    ARRAY['pizza', 'burger', 'sushi'],
    'client@test.com',
    'test123456',
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING;

  -- Vérifier si l'utilisateur RESTAURANT existe déjà
  SELECT id INTO restaurant_uuid FROM auth.users WHERE email = 'resto@test.com';
  
  -- Si l'utilisateur n'existe pas, le créer
  IF restaurant_uuid IS NULL THEN
    restaurant_uuid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password, email_confirmed_at,
      created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    )
    VALUES (
      restaurant_uuid,
      '00000000-0000-0000-0000-000000000000',
      'resto@test.com',
      crypt('test123456', gen_salt('bf')),
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      jsonb_build_object('role', 'restaurant'),
      false,
      'authenticated',
      'authenticated'
    );
  ELSE
    -- Mettre à jour le mot de passe si l'utilisateur existe déjà
    UPDATE auth.users
    SET encrypted_password = crypt('test123456', gen_salt('bf')),
        email_confirmed_at = now(),
        updated_at = now()
    WHERE id = restaurant_uuid;
  END IF;

  -- Créer le profil RESTAURANT
  INSERT INTO public.profiles (id, role, display_name, created_at, updated_at)
  VALUES (restaurant_uuid, 'restaurant', 'Restaurant Test', now(), now())
  ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

  -- Créer les données RESTAURANT avec email et password
  INSERT INTO public.restaurants (
    id, name, description, address, arrondissement, lat, lng,
    phone, instagram, price_level, cuisine_types,
    is_student_friendly, max_deals_per_day, email, password,
    created_at, updated_at
  )
  VALUES (
    restaurant_uuid,
    'Pizza Paradise Test',
    'Restaurant de test - Pizzas artisanales au feu de bois',
    '123 rue de Test, 75011 Paris',
    '11ème',
    48.8566,
    2.3522,
    '01 23 45 67 89',
    '@pizzaparadiseparis',
    '€€',
    ARRAY['pizza', 'italian'],
    true,
    50,
    'resto@test.com',
    'test123456',
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING;

  -- Créer un DEAL pour le restaurant
  INSERT INTO public.deals (
    restaurant_id, title, description, deal_type, category,
    min_group_size, is_active, badge, created_at, updated_at
  )
  VALUES (
    restaurant_uuid,
    '1 Pizza = 1 Pizza offerte',
    'Deal de test - Pizza au choix',
    '1+1',
    'pizza',
    2,
    true,
    '🔥 Populaire',
    now(),
    now()
  );

  RAISE NOTICE '✅ Données de test créées!';
  RAISE NOTICE '   Client UUID: %', client_uuid;
  RAISE NOTICE '   Restaurant UUID: %', restaurant_uuid;
  RAISE NOTICE '';
  RAISE NOTICE '📋 Comptes de test:';
  RAISE NOTICE '   👤 Client: client@test.com / test123456';
  RAISE NOTICE '   🍕 Restaurant: resto@test.com / test123456';

END $$;

-- ============================================================================
-- ÉTAPE 7 : VÉRIFICATION
-- ============================================================================

SELECT '✅ Tables créées:' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'clients', 'restaurants', 'deals', 'favorites')
ORDER BY table_name;

SELECT 'Utilisateurs créés:' as info;
SELECT id, email, email_confirmed_at IS NOT NULL as can_login
FROM auth.users
WHERE email IN ('client@test.com', 'resto@test.com');

SELECT 'Profiles créés:' as info;
SELECT * FROM public.profiles;

SELECT 'Clients créés (avec email/password):' as info;
SELECT id, email, password, age, is_student, main_arrondissement
FROM public.clients;

SELECT 'Restaurants créés (avec email/password):' as info;
SELECT id, name, email, password, arrondissement, phone
FROM public.restaurants;

SELECT 'Deals créés:' as info;
SELECT d.*, r.name as restaurant_name 
FROM public.deals d
LEFT JOIN public.restaurants r ON d.restaurant_id = r.id
ORDER BY d.created_at DESC;

SELECT '✅ Toutes les tables ont été recréées avec succès!' as result;

