-- CAFÉ DO PADRIM — Supabase schema
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  created_at timestamptz not null default now()
);
create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null, type text, phone text, email text, city text, status text, obs text,
  created_at timestamptz not null default now()
);
create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null, value numeric(12,2) default 0, interest text,
  stage text not null default 'Novo Lead', created_at timestamptz not null default now()
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null, price numeric(12,2) default 0, cost numeric(12,2) default 0,
  stock integer default 0, min integer default 0, created_at timestamptz not null default now()
);
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  customer text not null, total numeric(12,2) default 0,
  status text not null default 'Novo', date date, created_at timestamptz not null default now()
);
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null, date date, status text not null default 'A fazer',
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.customers enable row level security;
alter table public.leads enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.tasks enable row level security;

drop policy if exists profiles_select_own on public.profiles;
create policy profiles_select_own on public.profiles for select using (id=auth.uid());
drop policy if exists profiles_insert_own on public.profiles;
create policy profiles_insert_own on public.profiles for insert with check (id=auth.uid());

do $$
declare t text;
begin
 foreach t in array array['customers','leads','products','orders','tasks'] loop
  execute format('drop policy if exists own_select on public.%I',t);
  execute format('create policy own_select on public.%I for select using (user_id=auth.uid())',t);
  execute format('drop policy if exists own_insert on public.%I',t);
  execute format('create policy own_insert on public.%I for insert with check (user_id=auth.uid())',t);
  execute format('drop policy if exists own_update on public.%I',t);
  execute format('create policy own_update on public.%I for update using (user_id=auth.uid()) with check (user_id=auth.uid())',t);
  execute format('drop policy if exists own_delete on public.%I',t);
  execute format('create policy own_delete on public.%I for delete using (user_id=auth.uid())',t);
 end loop;
end $$;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,email) values(new.id,new.email)
 on conflict(id) do update set email=excluded.email;
 return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
