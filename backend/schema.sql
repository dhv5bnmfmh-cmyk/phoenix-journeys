-- Phoenix preliminary Supabase schema. Review before production.

create table explorers (
  id uuid primary key,
  display_name text,
  native_language text not null default 'vi',
  learning_language text not null default 'zh',
  script_mode text not null default 'simplified',
  level text not null default 'beginner',
  created_at timestamptz not null default now()
);

create table journeys (
  id text primary key,
  country_code text not null,
  city_code text not null,
  title_zh text not null,
  difficulty text not null,
  status text not null default 'draft',
  created_at timestamptz not null default now()
);

create table memories (
  id uuid primary key,
  explorer_id uuid references explorers(id),
  journey_id text references journeys(id),
  reflection text,
  created_at timestamptz not null default now()
);

create table feedback (
  id uuid primary key,
  explorer_id uuid references explorers(id),
  category text,
  body text not null,
  status text not null default 'received',
  public_response text,
  created_at timestamptz not null default now()
);

create table content_sources (
  id uuid primary key,
  journey_id text references journeys(id),
  claim_key text not null,
  source_title text not null,
  source_url text,
  source_type text not null,
  verified_at timestamptz
);

create table asset_licenses (
  id uuid primary key,
  asset_path text not null unique,
  origin text not null,
  license_type text not null,
  proof_url text,
  reviewed_at timestamptz
);
