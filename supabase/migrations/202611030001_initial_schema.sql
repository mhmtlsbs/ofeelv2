create table public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default 'OBO kullanıcısı',
 created_at timestamptz not null default now()
);
create table public.devices (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.profiles(id) on delete cascade,
 push_token text not null unique,
 platform text not null check(platform in ('android','ios'))
);
create table public.emoji_packs (
 id uuid primary key default gen_random_uuid(),
 code text not null unique,
 title text not null,
 is_active boolean not null default false
);
create table public.emojis (
 id uuid primary key default gen_random_uuid(),
 pack_id uuid not null references public.emoji_packs(id),
 code text not null unique,
 asset_path text not null,
 is_active boolean not null default false
);
create table public.conversations (
 id uuid primary key default gen_random_uuid(),
 created_by uuid not null references public.profiles(id),
 created_at timestamptz not null default now()
);
create table public.conversation_members (
 conversation_id uuid not null references public.conversations(id) on delete cascade,
 user_id uuid not null references public.profiles(id) on delete cascade,
 last_read_at timestamptz,
 primary key(conversation_id,user_id)
);
create table public.messages (
 id uuid primary key default gen_random_uuid(),
 conversation_id uuid not null references public.conversations(id) on delete cascade,
 sender_id uuid not null references public.profiles(id),
 emoji_id uuid not null references public.emojis(id),
 client_message_id uuid not null,
 created_at timestamptz not null default now(),
 unique(sender_id,client_message_id)
);
create index on public.messages(conversation_id,created_at desc);
create index on public.conversation_members(user_id);
alter table public.profiles enable row level security;
alter table public.devices enable row level security;
alter table public.emoji_packs enable row level security;
alter table public.emojis enable row level security;
alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.messages enable row level security;
create policy profile_read on public.profiles for select to authenticated using(id=auth.uid());
create policy profile_insert on public.profiles for insert to authenticated with check(id=auth.uid());
create policy profile_update on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid());
create policy devices_own on public.devices for all to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy packs_read on public.emoji_packs for select to authenticated using(is_active);
create policy emojis_read on public.emojis for select to authenticated using(is_active and exists(select 1 from public.emoji_packs p where p.id=pack_id and p.is_active));
create function public.is_conversation_member(p_id uuid) returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.conversation_members where conversation_id=p_id and user_id=auth.uid()); $$;
revoke all on function public.is_conversation_member(uuid) from public;
grant execute on function public.is_conversation_member(uuid) to authenticated;
create policy conversations_read on public.conversations for select to authenticated using(public.is_conversation_member(id));
create policy members_read on public.conversation_members for select to authenticated using(public.is_conversation_member(conversation_id));
create policy messages_read on public.messages for select to authenticated using(public.is_conversation_member(conversation_id));
create policy messages_send on public.messages for insert to authenticated with check(sender_id=auth.uid() and public.is_conversation_member(conversation_id) and exists(select 1 from public.emojis e where e.id=emoji_id and e.is_active));
-- Conversation creation requires a trusted RPC to be implemented later.
-- Never expose service_role credentials to the client.
