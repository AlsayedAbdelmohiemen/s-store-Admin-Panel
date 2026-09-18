-- ==========================================================
-- S-Store & Admin Panel - Full Supabase Database Schema
-- Run this script in your Supabase Dashboard -> SQL Editor
-- ==========================================================

-- 1. Enable UUID Extension
create extension if not exists "uuid-ossp";

-- 2. Categories Table
create table if not exists public."Categories" (
    id text primary key default uuid_generate_v4()::text,
    "Name" text not null,
    "Image" text default '',
    "ParentId" text default '',
    "IsFeatured" boolean default false,
    created_at timestamptz default now()
);

-- 3. Brands Table
create table if not exists public."Brands" (
    "Id" text primary key default uuid_generate_v4()::text,
    "Name" text not null,
    "Image" text default '',
    "IsFeatured" boolean default false,
    "ProductsCount" integer default 0,
    created_at timestamptz default now()
);

-- 4. Banners Table
create table if not exists public."Banners" (
    id text primary key default uuid_generate_v4()::text,
    "ImageUrl" text not null,
    "TargetScreen" text default '/products',
    "Active" boolean default true,
    created_at timestamptz default now()
);

-- 5. Products Table
create table if not exists public."Products" (
    id text primary key default uuid_generate_v4()::text,
    "Title" text not null,
    "Stock" integer default 0,
    "Price" double precision default 0.0,
    "SalePrice" double precision default 0.0,
    "Thumbnail" text default '',
    "ProductType" text default 'single',
    "SKU" text default '',
    "Description" text default '',
    "CategoryId" text default '',
    "Brand" jsonb,
    "Images" jsonb default '[]'::jsonb,
    "IsFeatured" boolean default false,
    "Date" timestamptz default now(),
    created_at timestamptz default now()
);

-- 6. Orders Table
create table if not exists public."Orders" (
    id text primary key default uuid_generate_v4()::text,
    "userId" text default '',
    "status" text default 'processing',
    "totalAmount" double precision default 0.0,
    "orderDate" timestamptz default now(),
    "paymentMethod" text default 'Paypal',
    "address" jsonb,
    "deliveryDate" timestamptz,
    "items" jsonb default '[]'::jsonb,
    created_at timestamptz default now()
);

-- 7. Ensure Users Table & Add Role Column if missing
create table if not exists public."Users" (
    id uuid primary key default gen_random_uuid(),
    "FirstName" text default '',
    "LastName" text default '',
    "Username" text default '',
    "Email" text default '',
    "PhoneNumber" text default '',
    "ProfilePicture" text default '',
    "Role" text default 'user',
    created_at timestamptz default now()
);

-- Add Role column and other columns to existing Users table if missing
alter table public."Users" add column if not exists "Role" text default 'user';
alter table public."Users" add column if not exists "FirstName" text default '';
alter table public."Users" add column if not exists "LastName" text default '';
alter table public."Users" add column if not exists "Username" text default '';
alter table public."Users" add column if not exists "Email" text default '';
alter table public."Users" add column if not exists "PhoneNumber" text default '';
alter table public."Users" add column if not exists "ProfilePicture" text default '';

-- ==========================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Allow Full Access for Authenticated and Anon (Admin Panel & App)
-- ==========================================================

alter table public."Categories" enable row level security;
alter table public."Brands" enable row level security;
alter table public."Banners" enable row level security;
alter table public."Products" enable row level security;
alter table public."Orders" enable row level security;
alter table public."Users" enable row level security;

-- Drop existing policies if any to avoid duplication errors
drop policy if exists "Allow full access to Categories" on public."Categories";
drop policy if exists "Allow full access to Brands" on public."Brands";
drop policy if exists "Allow full access to Banners" on public."Banners";
drop policy if exists "Allow full access to Products" on public."Products";
drop policy if exists "Allow full access to Orders" on public."Orders";
drop policy if exists "Allow full access to Users" on public."Users";

-- Create unrestricted CRUD policies for all tables
create policy "Allow full access to Categories" on public."Categories" for all using (true) with check (true);
create policy "Allow full access to Brands" on public."Brands" for all using (true) with check (true);
create policy "Allow full access to Banners" on public."Banners" for all using (true) with check (true);
create policy "Allow full access to Products" on public."Products" for all using (true) with check (true);
create policy "Allow full access to Orders" on public."Orders" for all using (true) with check (true);
create policy "Allow full access to Users" on public."Users" for all using (true) with check (true);

-- ==========================================================
-- SAMPLE SEED DATA (Brands, Banners, Products, Orders)
-- ==========================================================

-- Seed Brands
insert into public."Brands" ("Id", "Name", "Image", "IsFeatured", "ProductsCount")
values 
    ('brand_nike', 'Nike', 'https://raw.githubusercontent.com/flutter/website/main/src/assets/images/shared/brand/flutter/logo/flutter-lockup.png', true, 24),
    ('brand_adidas', 'Adidas', 'https://raw.githubusercontent.com/flutter/website/main/src/assets/images/shared/brand/flutter/logo/flutter-lockup.png', true, 18),
    ('brand_apple', 'Apple', 'https://raw.githubusercontent.com/flutter/website/main/src/assets/images/shared/brand/flutter/logo/flutter-lockup.png', true, 12),
    ('brand_zara', 'Zara', 'https://raw.githubusercontent.com/flutter/website/main/src/assets/images/shared/brand/flutter/logo/flutter-lockup.png', false, 8)
on conflict ("Id") do nothing;

-- Seed Banners
insert into public."Banners" ("id", "ImageUrl", "TargetScreen", "Active")
values
    ('banner_01', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', '/products', true),
    ('banner_02', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800', '/products', true)
on conflict ("id") do nothing;

-- Seed Sample Products
insert into public."Products" ("id", "Title", "Stock", "Price", "SalePrice", "Thumbnail", "ProductType", "SKU", "Description", "CategoryId", "Brand", "IsFeatured")
values
    ('prod_nike_air', 'Nike Air Max 270', 35, 150.00, 129.99, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'single', 'NIKE-AIR-270', 'Legendary Air Max cushioning for everyday comfort.', '1', '{"Id": "brand_nike", "Name": "Nike", "Image": ""}'::jsonb, true),
    ('prod_adidas_boost', 'Adidas Ultraboost Light', 20, 190.00, 169.00, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=400', 'single', 'ADI-BOOST-01', 'High-performance running shoe with maximum energy return.', '1', '{"Id": "brand_adidas", "Name": "Adidas", "Image": ""}'::jsonb, true),
    ('prod_apple_watch', 'Apple Watch Series 9', 15, 399.00, 379.00, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', 'single', 'APL-W9-45', 'Smarter, brighter, and mightier smartwatch.', '1', '{"Id": "brand_apple", "Name": "Apple", "Image": ""}'::jsonb, true)
on conflict ("id") do nothing;

-- Seed Sample Orders
insert into public."Orders" ("id", "userId", "status", "totalAmount", "orderDate", "paymentMethod", "items")
values
    ('ord_101', '', 'delivered', 279.99, now() - interval '2 days', 'Credit Card', '[{"productId": "prod_nike_air", "title": "Nike Air Max 270", "price": 129.99, "quantity": 1}, {"productId": "prod_adidas_boost", "title": "Adidas Ultraboost Light", "price": 150.00, "quantity": 1}]'::jsonb),
    ('ord_102', '', 'processing', 379.00, now() - interval '1 day', 'Paypal', '[{"productId": "prod_apple_watch", "title": "Apple Watch Series 9", "price": 379.00, "quantity": 1}]'::jsonb),
    ('ord_103', '', 'shipped', 129.99, now() - interval '4 hours', 'Cash on Delivery', '[{"productId": "prod_nike_air", "title": "Nike Air Max 270", "price": 129.99, "quantity": 1}]'::jsonb)
on conflict ("id") do nothing;
