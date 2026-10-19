-- El correo vive en Auth (auth.users). La tabla profiles solo necesita
-- id, username y full_name, como en la guía del laboratorio.
alter table public.profiles drop column if exists email;
