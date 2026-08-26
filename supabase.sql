create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price text,
  category text,
  image_url text not null,
  affiliate_url text not null,
  description text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;

create policy "public read active products"
on public.products for select to anon, authenticated
using (active = true);

create policy "authenticated insert products"
on public.products for insert to authenticated
with check (true);

create policy "authenticated update products"
on public.products for update to authenticated
using (true) with check (true);

create policy "authenticated delete products"
on public.products for delete to authenticated
using (true);

create policy "public read product images"
on storage.objects for select to public
using (bucket_id = 'product-images');

create policy "authenticated upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images');

create policy "authenticated delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images');
