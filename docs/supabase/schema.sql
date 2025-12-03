-- ============================================================================
-- SCHEMA SUPABASE - LA DALLE
-- Base de données pour l'application de food deals à Paris
-- ============================================================================

-- 1. Table PROFILES (profil de base pour tous les utilisateurs)
-- ============================================================================
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('client', 'restaurant')),
  display_name text,
  avatar_url text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- RLS pour profiles
alter table public.profiles enable row level security;

create policy "Les profils sont visibles par tous"
  on public.profiles for select
  using (true);

create policy "Les utilisateurs peuvent mettre à jour leur propre profil"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Les utilisateurs peuvent créer leur profil"
  on public.profiles for insert
  with check (auth.uid() = id);


-- 2. Table CLIENTS (informations spécifiques aux clients)
-- ============================================================================
create table public.clients (
  id uuid primary key references public.profiles(id) on delete cascade,
  age int,
  is_student boolean default false,
  school_name text,
  main_arrondissement text,
  budget_range text check (budget_range in ('€', '€€', '€€€')),
  favorite_categories text[],
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- RLS pour clients
alter table public.clients enable row level security;

create policy "Les clients sont visibles par tous"
  on public.clients for select
  using (true);

create policy "Les clients peuvent mettre à jour leur propre profil"
  on public.clients for update
  using (auth.uid() = id);

create policy "Les clients peuvent créer leur profil"
  on public.clients for insert
  with check (auth.uid() = id);


-- 3. Table RESTAURANTS
-- ============================================================================
create table public.restaurants (
  id uuid primary key references public.profiles(id) on delete cascade,
  name text not null,
  description text,
  address text,
  arrondissement text,
  lat double precision,
  lng double precision,
  phone text,
  website text,
  instagram text,
  price_level text check (price_level in ('€', '€€', '€€€')),
  cuisine_types text[],
  is_student_friendly boolean default true,
  max_deals_per_day int default 50,
  image_url text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- RLS pour restaurants
alter table public.restaurants enable row level security;

create policy "Les restaurants sont visibles par tous"
  on public.restaurants for select
  using (true);

create policy "Les restaurants peuvent mettre à jour leur propre profil"
  on public.restaurants for update
  using (auth.uid() = id);

create policy "Les restaurants peuvent créer leur profil"
  on public.restaurants for insert
  with check (auth.uid() = id);


-- 4. Table DEALS (offres "1+1" créées par les restaurants)
-- ============================================================================
create table public.deals (
  id bigserial primary key,
  restaurant_id uuid references public.restaurants(id) on delete cascade,
  title text not null,
  description text,
  deal_type text default '1+1',
  category text,
  min_group_size int default 2,
  max_group_size int,
  valid_from date,
  valid_to date,
  days_of_week text[],
  start_time time,
  end_time time,
  is_active boolean default true,
  badge text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- RLS pour deals
alter table public.deals enable row level security;

create policy "Les deals sont visibles par tous"
  on public.deals for select
  using (is_active = true);

create policy "Les restaurants peuvent créer leurs deals"
  on public.deals for insert
  with check (auth.uid() = restaurant_id);

create policy "Les restaurants peuvent mettre à jour leurs deals"
  on public.deals for update
  using (auth.uid() = restaurant_id);

create policy "Les restaurants peuvent supprimer leurs deals"
  on public.deals for delete
  using (auth.uid() = restaurant_id);


-- 5. Table FAVORITES (deals favoris des clients)
-- ============================================================================
create table public.favorites (
  id bigserial primary key,
  client_id uuid references public.clients(id) on delete cascade,
  deal_id bigint references public.deals(id) on delete cascade,
  created_at timestamp with time zone default now(),
  unique(client_id, deal_id)
);

-- RLS pour favorites
alter table public.favorites enable row level security;

create policy "Les clients peuvent voir leurs favoris"
  on public.favorites for select
  using (auth.uid() = client_id);

create policy "Les clients peuvent ajouter des favoris"
  on public.favorites for insert
  with check (auth.uid() = client_id);

create policy "Les clients peuvent supprimer leurs favoris"
  on public.favorites for delete
  using (auth.uid() = client_id);


-- 6. Triggers pour updated_at
-- ============================================================================
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_updated_at
  before update on public.profiles
  for each row execute function public.handle_updated_at();

create trigger set_updated_at
  before update on public.clients
  for each row execute function public.handle_updated_at();

create trigger set_updated_at
  before update on public.restaurants
  for each row execute function public.handle_updated_at();

create trigger set_updated_at
  before update on public.deals
  for each row execute function public.handle_updated_at();


-- 7. Fonctions utilitaires
-- ============================================================================

-- Fonction pour obtenir le role d'un utilisateur
create or replace function public.get_user_role(user_id uuid)
returns text as $$
  select role from public.profiles where id = user_id;
$$ language sql security definer;

-- Fonction pour obtenir les deals d'un restaurant
create or replace function public.get_restaurant_deals(resto_id uuid)
returns setof public.deals as $$
  select * from public.deals where restaurant_id = resto_id;
$$ language sql security definer;


-- 8. Indexes pour les performances
-- ============================================================================
create index idx_deals_restaurant_id on public.deals(restaurant_id);
create index idx_deals_is_active on public.deals(is_active);
create index idx_deals_category on public.deals(category);
create index idx_restaurants_arrondissement on public.restaurants(arrondissement);
create index idx_favorites_client_id on public.favorites(client_id);
create index idx_favorites_deal_id on public.favorites(deal_id);

