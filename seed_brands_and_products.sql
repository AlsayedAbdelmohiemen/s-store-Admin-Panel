-- ==========================================================
-- S-Store: Seed High-Quality Brands & Products
-- Run this in Supabase Dashboard -> SQL Editor
-- ==========================================================

-- 1. Insert/Update Brands with Official High-Quality Logos
insert into public."Brands" ("Id", "Name", "Image", "IsFeatured", "ProductsCount")
values 
    ('brand_nike', 'Nike', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/640px-Logo_NIKE.svg.png', true, 4),
    ('brand_adidas', 'Adidas', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/640px-Adidas_Logo.svg.png', true, 4),
    ('brand_apple', 'Apple', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/505px-Apple_logo_black.svg.png', true, 4),
    ('brand_puma', 'Puma', 'https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Puma_AG.svg/640px-Puma_AG.svg.png', true, 2),
    ('brand_zara', 'Zara', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/640px-Zara_Logo.svg.png', true, 2),
    ('brand_jordan', 'Jordan', 'https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Jumpman_logo.svg/640px-Jumpman_logo.svg.png', true, 2)
on conflict ("Id") do update set
    "Name" = excluded."Name",
    "Image" = excluded."Image",
    "IsFeatured" = excluded."IsFeatured",
    "ProductsCount" = excluded."ProductsCount";

-- 2. Insert Comprehensive Products per Brand
insert into public."Products" ("id", "Title", "Stock", "Price", "SalePrice", "Thumbnail", "ProductType", "SKU", "Description", "CategoryId", "Brand", "Images", "IsFeatured")
values
    -- NIKE PRODUCTS
    (
        'prod_nike_air_270', 
        'Nike Air Max 270', 
        35, 160.00, 139.99, 
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600', 
        'single', 'NIKE-AIR-270', 
        'Iconic Air Max cushioning unit delivering unrivaled, all-day comfort with a sleek sporty silhouette.', 
        '1', 
        '{"Id": "brand_nike", "Name": "Nike", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/640px-Logo_NIKE.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800", "https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_nike_pegasus', 
        'Nike Air Zoom Pegasus 40', 
        28, 140.00, 119.99, 
        'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=600', 
        'single', 'NIKE-PEG-40', 
        'A springy ride for any run, the Peg return to help you accomplish your fitness goals.', 
        '1', 
        '{"Id": "brand_nike", "Name": "Nike", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/640px-Logo_NIKE.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_nike_hoodie', 
        'Nike Sportswear Club Fleece Hoodie', 
        45, 65.00, 52.00, 
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600', 
        'single', 'NIKE-CLB-HD', 
        'Brushed-back fleece is soft and smooth against the skin. Classic style meets modern comfort.', 
        '3', 
        '{"Id": "brand_nike", "Name": "Nike", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/640px-Logo_NIKE.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800"]'::jsonb, 
        false
    ),
    (
        'prod_nike_cap', 
        'Nike Dri-FIT Pro Training Cap', 
        60, 32.00, 26.99, 
        'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600', 
        'single', 'NIKE-CAP-01', 
        'Sweat-wicking Dri-FIT technology keeps you dry and focused through every high-intensity workout.', 
        '1', 
        '{"Id": "brand_nike", "Name": "Nike", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/640px-Logo_NIKE.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=800"]'::jsonb, 
        false
    ),

    -- ADIDAS PRODUCTS
    (
        'prod_adidas_ultraboost', 
        'Adidas Ultraboost Light Running Shoes', 
        22, 190.00, 169.00, 
        'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600', 
        'single', 'ADI-BOOST-LT', 
        'Experience epic energy with the lightest Ultraboost ever made. High-performance Continental rubber grip.', 
        '1', 
        '{"Id": "brand_adidas", "Name": "Adidas", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/640px-Adidas_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_adidas_superstar', 
        'Adidas Originals Superstar Classic', 
        30, 105.00, 89.99, 
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=600', 
        'single', 'ADI-SUP-01', 
        'The iconic shell-toe basketball sneaker turned street-style staple with full-grain leather upper.', 
        '6', 
        '{"Id": "brand_adidas", "Name": "Adidas", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/640px-Adidas_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_adidas_tiro', 
        'Adidas Tiro 23 League Track Pants', 
        40, 55.00, 44.99, 
        'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=600', 
        'single', 'ADI-TIRO-23', 
        'Moisture-absorbing AEROREADY track pants built for on-pitch speed and off-pitch relaxation.', 
        '3', 
        '{"Id": "brand_adidas", "Name": "Adidas", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/640px-Adidas_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800"]'::jsonb, 
        false
    ),
    (
        'prod_adidas_predator', 
        'Adidas Predator Accuracy Elite FG Boots', 
        15, 230.00, 199.99, 
        'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=600', 
        'single', 'ADI-PRED-FG', 
        'Pinpoint accuracy football boots designed to strike with ultimate precision on firm ground.', 
        '1', 
        '{"Id": "brand_adidas", "Name": "Adidas", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/640px-Adidas_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=800"]'::jsonb, 
        false
    ),

    -- APPLE PRODUCTS
    (
        'prod_apple_iphone_15', 
        'Apple iPhone 15 Pro Max 256GB', 
        18, 1199.00, 1149.00, 
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600', 
        'single', 'APL-IP15PM-256', 
        'Forged in aerospace-grade titanium with the groundbreaking A17 Pro chip and 48MP camera system.', 
        '2', 
        '{"Id": "brand_apple", "Name": "Apple", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/505px-Apple_logo_black.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_apple_macbook', 
        'Apple MacBook Air 15-inch M3', 
        12, 1299.00, 1249.00, 
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600', 
        'single', 'APL-MBA15-M3', 
        'Strikingly thin design with stunning Liquid Retina display and up to 18 hours of battery life.', 
        '2', 
        '{"Id": "brand_apple", "Name": "Apple", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/505px-Apple_logo_black.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_apple_watch_9', 
        'Apple Watch Series 9 GPS 45mm', 
        25, 429.00, 399.00, 
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600', 
        'single', 'APL-W9-45', 
        'The most powerful watch chip ever, magical double tap gesture, and advanced health sensors.', 
        '2', 
        '{"Id": "brand_apple", "Name": "Apple", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/505px-Apple_logo_black.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_apple_airpods', 
        'Apple AirPods Pro (2nd Generation)', 
        35, 249.00, 199.00, 
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600', 
        'single', 'APL-APP2-USBC', 
        'Up to 2x more Active Noise Cancellation, Adaptive Audio, and personalized Spatial Audio.', 
        '2', 
        '{"Id": "brand_apple", "Name": "Apple", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/505px-Apple_logo_black.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=800"]'::jsonb, 
        false
    ),

    -- PUMA PRODUCTS
    (
        'prod_puma_nitro', 
        'Puma Velocity Nitro 3 Running Shoes', 
        20, 135.00, 114.99, 
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600', 
        'single', 'PUMA-NITRO-3', 
        'NITRO foam technology providing superior responsiveness and cushioning in a featherlight package.', 
        '1', 
        '{"Id": "brand_puma", "Name": "Puma", "Image": "https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Puma_AG.svg/640px-Puma_AG.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_puma_track_jacket', 
        'Puma T7 Iconic Track Jacket', 
        30, 80.00, 64.99, 
        'https://images.unsplash.com/photo-1548883354-7622d03aca27?w=600', 
        'single', 'PUMA-T7-JKT', 
        'Straight from the PUMA archives with 7cm signature contrast stripes along the sleeves.', 
        '3', 
        '{"Id": "brand_puma", "Name": "Puma", "Image": "https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Puma_AG.svg/640px-Puma_AG.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1548883354-7622d03aca27?w=800"]'::jsonb, 
        false
    ),

    -- ZARA PRODUCTS
    (
        'prod_zara_blazer', 
        'Zara Tailored Slim Fit Suit Blazer', 
        16, 139.00, 109.99, 
        'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600', 
        'single', 'ZARA-BLZ-01', 
        'Sharp, modern tailoring with notch lapels, structured shoulders, and premium lightweight fabric.', 
        '3', 
        '{"Id": "brand_zara", "Name": "Zara", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/640px-Zara_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_zara_linen_shirt', 
        'Zara 100% Linen Casual Shirt', 
        35, 59.90, 45.90, 
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600', 
        'single', 'ZARA-LIN-SHT', 
        'Airy pure linen shirt with spread collar and clean cuffed sleeves. Ideal for warm season styling.', 
        '3', 
        '{"Id": "brand_zara", "Name": "Zara", "Image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/640px-Zara_Logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800"]'::jsonb, 
        false
    ),

    -- JORDAN PRODUCTS
    (
        'prod_jordan_1_high', 
        'Air Jordan 1 Retro High OG', 
        14, 180.00, 169.99, 
        'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=600', 
        'single', 'JRD-AJ1-OG', 
        'The legend that started it all. Premium genuine leather construction with encapsulated Air cushioning.', 
        '6', 
        '{"Id": "brand_jordan", "Name": "Jordan", "Image": "https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Jumpman_logo.svg/640px-Jumpman_logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=800"]'::jsonb, 
        true
    ),
    (
        'prod_jordan_tee', 
        'Jordan Flight Essentials Graphic Tee', 
        50, 45.00, 34.99, 
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600', 
        'single', 'JRD-FLT-TEE', 
        'Heavyweight premium cotton tee with clean Jumpman heritage embroidery on the chest.', 
        '3', 
        '{"Id": "brand_jordan", "Name": "Jordan", "Image": "https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Jumpman_logo.svg/640px-Jumpman_logo.svg.png"}'::jsonb, 
        '["https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800"]'::jsonb, 
        false
    )
on conflict ("id") do update set
    "Title" = excluded."Title",
    "Stock" = excluded."Stock",
    "Price" = excluded."Price",
    "SalePrice" = excluded."SalePrice",
    "Thumbnail" = excluded."Thumbnail",
    "ProductType" = excluded."ProductType",
    "SKU" = excluded."SKU",
    "Description" = excluded."Description",
    "CategoryId" = excluded."CategoryId",
    "Brand" = excluded."Brand",
    "Images" = excluded."Images",
    "IsFeatured" = excluded."IsFeatured";
