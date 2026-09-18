import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/data/models/category_model.dart';
import 'package:admin_panel/data/models/brand_model.dart';
import 'package:admin_panel/data/models/banner_model.dart';
import 'package:admin_panel/data/models/product_model.dart';

void main() {
  group('Catalog Models Unit Tests', () {
    test('CategoryModel fromJson and toJson serialization', () {
      final json = {
        'id': 'cat_01',
        'Name': 'Footwear',
        'Image': 'https://example.com/shoes.png',
        'ParentId': 'cat_root',
        'IsFeatured': true,
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 'cat_01');
      expect(category.name, 'Footwear');
      expect(category.image, 'https://example.com/shoes.png');
      expect(category.parentId, 'cat_root');
      expect(category.isFeatured, isTrue);

      final outJson = category.toJson();
      expect(outJson['Name'], 'Footwear');
      expect(outJson['IsFeatured'], isTrue);
    });

    test('BrandModel fromJson and toJson serialization', () {
      final json = {
        'Id': 'brand_nike',
        'Name': 'Nike',
        'Image': 'https://example.com/nike.png',
        'IsFeatured': true,
        'ProductsCount': 42,
      };

      final brand = BrandModel.fromJson(json);

      expect(brand.id, 'brand_nike');
      expect(brand.name, 'Nike');
      expect(brand.productsCount, 42);
      expect(brand.isFeatured, isTrue);

      final outJson = brand.toJson();
      expect(outJson['Name'], 'Nike');
      expect(outJson['ProductsCount'], 42);
    });

    test('BannerModel fromJson and toJson serialization', () {
      final json = {
        'id': 'banner_01',
        'ImageUrl': 'https://example.com/promo.jpg',
        'TargetScreen': '/products',
        'Active': true,
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, 'banner_01');
      expect(banner.imageUrl, 'https://example.com/promo.jpg');
      expect(banner.targetScreen, '/products');
      expect(banner.active, isTrue);

      final outJson = banner.toJson();
      expect(outJson['ImageUrl'], 'https://example.com/promo.jpg');
      expect(outJson['Active'], isTrue);
    });

    test('ProductModel fromJson with embedded brand and toJson', () {
      final json = {
        'id': 'prod_99',
        'Title': 'Nike Running Shoes',
        'Stock': 15,
        'Price': 129.99,
        'SalePrice': 99.99,
        'Thumbnail': 'https://example.com/running_thumb.png',
        'ProductType': 'single',
        'SKU': 'RUN-001',
        'IsFeatured': true,
        'CategoryId': 'cat_01',
        'Brand': {
          'Id': 'brand_nike',
          'Name': 'Nike',
          'Image': 'https://example.com/nike.png',
        },
        'Images': [
          'https://example.com/img1.png',
          'https://example.com/img2.png',
        ],
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 'prod_99');
      expect(product.title, 'Nike Running Shoes');
      expect(product.price, 129.99);
      expect(product.salePrice, 99.99);
      expect(product.stock, 15);
      expect(product.brand, isNotNull);
      expect(product.brand!.name, 'Nike');
      expect(product.images?.length, 2);

      final outJson = product.toJson();
      expect(outJson['Title'], 'Nike Running Shoes');
      expect(outJson['Price'], 129.99);
      expect(outJson['Brand'], isNotNull);
    });
  });
}
