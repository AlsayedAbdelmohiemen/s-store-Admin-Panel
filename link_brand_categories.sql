-- ==========================================================
-- S-Store: Create & Populate BrandCategories Table
-- Run this in Supabase Dashboard -> SQL Editor
-- ==========================================================

create table if not exists public."BrandCategories" (
    id text primary key default uuid_generate_v4()::text,
    "brandId" text not null,
    "categoryId" text not null,
    created_at timestamptz default now()
);

alter table public."BrandCategories" enable row level security;
drop policy if exists "Allow full access to BrandCategories" on public."BrandCategories";
create policy "Allow full access to BrandCategories" on public."BrandCategories" for all using (true) with check (true);

-- Clear old mappings if any
truncate table public."BrandCategories";

-- Insert Category <-> Brand Relationships
insert into public."BrandCategories" ("brandId", "categoryId") values
    -- 1. Sports: Nike, Adidas, Puma
    ('brand_nike', '1'),
    ('brand_adidas', '1'),
    ('brand_puma', '1'),

    -- 2. Electronics: Apple
    ('brand_apple', '2'),

    -- 3. Clothes: Zara, Nike, Jordan
    ('brand_zara', '3'),
    ('brand_nike', '3'),
    ('brand_jordan', '3'),

    -- 6. Shoes: Nike, Adidas, Jordan, Puma
    ('brand_nike', '6'),
    ('brand_adidas', '6'),
    ('brand_jordan', '6'),
    ('brand_puma', '6');
