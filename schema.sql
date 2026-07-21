-- ============================================================
--  SAN Blinds — database setup for Supabase
--  Run once: Supabase dashboard → SQL Editor → New query →
--  paste ALL of this → Run.  Safe to run again if needed.
-- ============================================================

-- 1) TABLES ---------------------------------------------------
create table if not exists public.clients (
  id         uuid primary key default gen_random_uuid(),
  name       text not null default '',
  contact    text default '',
  address    text default '',
  phone      text default '',
  email      text default '',
  notes      text default '',
  created_at timestamptz default now()
);

create table if not exists public.jobs (
  id           uuid primary key default gen_random_uuid(),
  san_ref      text default '',
  client_ref   text default '',
  client_id    uuid references public.clients(id) on delete set null,
  job_name     text default '',
  job_address  text default '',
  date_received date,
  status       text default 'Not Started',
  notes        text default '',
  windows      jsonb not null default '[]'::jsonb,
  created_at   timestamptz default now()
);

create table if not exists public.holidays (
  id         uuid primary key default gen_random_uuid(),
  day        date not null,
  name       text default '',
  created_at timestamptz default now()
);

-- 2) SECURITY: only signed-in staff can read or write ---------
alter table public.clients  enable row level security;
alter table public.jobs     enable row level security;
alter table public.holidays enable row level security;

drop policy if exists "staff full clients"  on public.clients;
drop policy if exists "staff full jobs"      on public.jobs;
drop policy if exists "staff full holidays"  on public.holidays;

create policy "staff full clients"  on public.clients
  for all to authenticated using (true) with check (true);
create policy "staff full jobs"      on public.jobs
  for all to authenticated using (true) with check (true);
create policy "staff full holidays"  on public.holidays
  for all to authenticated using (true) with check (true);

-- 3) DATA API GRANTS (required for new projects) --------------
--    Row Level Security above still restricts access to
--    logged-in staff; these grants just expose the tables.
grant usage on schema public to authenticated;
grant select, insert, update, delete
  on public.clients, public.jobs, public.holidays
  to authenticated;

-- 4) LIVE SYNC: push changes to all staff in real time --------
do $$
begin
  begin alter publication supabase_realtime add table public.clients;  exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.jobs;      exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.holidays;  exception when duplicate_object then null; end;
end $$;

-- 5) SAMPLE DATA (optional — delete these lines to start empty)
insert into public.clients (id, name, contact, address, phone, email)
values ('00000000-0000-0000-0000-0000000000c1',
        'Shoreline Blinds', 'Tenille Kingston',
        '316 Clarence Street, Howrah', '0447 337 546',
        'Tenille@shorelineblinds.com.au')
on conflict (id) do nothing;

insert into public.jobs
  (san_ref, client_ref, client_id, job_name, job_address, date_received, status, windows)
values
  ('S 5676', 'J 3431', '00000000-0000-0000-0000-0000000000c1',
   'Wilson Homes (316 Clarence St)', '316 Clarence Street, Howrah',
   current_date, 'In Production',
   '[{"id":"w1","name":"Kitchen","faceRec":"Face / Make","width":1200,"drop":1000},
     {"id":"w2","name":"Bed 1","faceRec":"Rec / Tight","width":900,"drop":900},
     {"id":"w3","name":"Bed 2","faceRec":"Rec / Tight","width":1000,"drop":2000}]'::jsonb)
on conflict do nothing;

-- Done. Now add your staff logins under Authentication → Users.
