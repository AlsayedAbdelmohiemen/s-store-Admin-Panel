-- ==========================================================
-- S-Store & Admin Panel: Fix Brand Images
-- Run this in Supabase Dashboard -> SQL Editor
-- ==========================================================

-- 1. Update Brands Table with clean bundled asset paths (instant & offline in app)
update public."Brands" set "Image" = 'assets/icons/brands/nike.png' where "Name" ilike '%nike%';
update public."Brands" set "Image" = 'assets/icons/brands/adidas-logo.png' where "Name" ilike '%adidas%';
update public."Brands" set "Image" = 'assets/icons/brands/apple-logo.png' where "Name" ilike '%apple%';
update public."Brands" set "Image" = 'assets/icons/brands/jordan-logo.png' where "Name" ilike '%jordan%';
update public."Brands" set "Image" = 'assets/icons/brands/puma-logo.png' where "Name" ilike '%puma%';
update public."Brands" set "Image" = 'assets/icons/brands/zara-logo.png' where "Name" ilike '%zara%';

-- 2. Also insert them if any doesn't exist
insert into public."Brands" ("Id", "Name", "Image", "IsFeatured", "ProductsCount")
values 
    ('brand_nike', 'Nike', 'assets/icons/brands/nike.png', true, 4),
    ('brand_adidas', 'Adidas', 'assets/icons/brands/adidas-logo.png', true, 4),
    ('brand_apple', 'Apple', 'assets/icons/brands/apple-logo.png', true, 4),
    ('brand_puma', 'Puma', 'assets/icons/brands/puma-logo.png', true, 2),
    ('brand_zara', 'Zara', 'assets/icons/brands/zara-logo.png', true, 2),
    ('brand_jordan', 'Jordan', 'assets/icons/brands/jordan-logo.png', true, 2)
on conflict ("Id") do update set
    "Image" = excluded."Image",
    "Name" = excluded."Name",
    "IsFeatured" = excluded."IsFeatured",
    "ProductsCount" = excluded."ProductsCount";

-- 3. Update Brand JSON in Products
update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/nike.png"')
where "Brand"->>'Name' ilike '%nike%';

update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/adidas-logo.png"')
where "Brand"->>'Name' ilike '%adidas%';

update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/apple-logo.png"')
where "Brand"->>'Name' ilike '%apple%';

update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/jordan-logo.png"')
where "Brand"->>'Name' ilike '%jordan%';

update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/puma-logo.png"')
where "Brand"->>'Name' ilike '%puma%';

update public."Products"
set "Brand" = jsonb_set("Brand", '{Image}', '"assets/icons/brands/zara-logo.png"')
where "Brand"->>'Name' ilike '%zara%';
