-- Laboratorio 5 · Registro de usuarios
--
-- Script de referencia para crear la tabla `profiles` en Supabase.
-- Ejecutarlo manualmente en el SQL Editor del proyecto.
--
-- IMPORTANTE: el flujo de la guía inserta el perfil desde la app justo
-- después de crear la cuenta en Auth. Para que la política de INSERT funcione
-- debe existir una sesión activa; si el proyecto exige confirmar el correo,
-- el registro fallará hasta confirmarlo (o hasta desactivar esa opción en
-- Authentication > Providers > Email).

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null unique,
  full_name text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles: leer el perfil propio" on public.profiles;
create policy "profiles: leer el perfil propio"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "profiles: insertar el perfil propio" on public.profiles;
create policy "profiles: insertar el perfil propio"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "profiles: actualizar el perfil propio" on public.profiles;
create policy "profiles: actualizar el perfil propio"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);
