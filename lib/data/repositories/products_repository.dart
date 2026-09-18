import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductsRepository extends GetxController {
  static ProductsRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _supabase.from('Products').select();
      return (response as List).map((data) => ProductModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching products: $e';
    }
  }

  /// Create new product
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _supabase.from('Products').insert({
        'Title': product.title,
        'Stock': product.stock,
        'Price': product.price,
        'SalePrice': product.salePrice,
        'Thumbnail': product.thumbnail,
        'ProductType': product.productType,
        'SKU': product.sku,
        'Description': product.description,
        'CategoryId': product.categoryId,
        'IsFeatured': product.isFeatured ?? false,
        'Brand': product.brand?.toJson(),
        'Images': product.images ?? [],
      }).select().single();
      return ProductModel.fromJson(response);
    } catch (e) {
      throw 'Error creating product: $e';
    }
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _supabase.from('Products').update({
        'Title': product.title,
        'Stock': product.stock,
        'Price': product.price,
        'SalePrice': product.salePrice,
        'Thumbnail': product.thumbnail,
        'ProductType': product.productType,
        'SKU': product.sku,
        'Description': product.description,
        'CategoryId': product.categoryId,
        'IsFeatured': product.isFeatured ?? false,
        'Brand': product.brand?.toJson(),
        'Images': product.images ?? [],
      }).eq('id', product.id);
    } catch (e) {
      throw 'Error updating product: $e';
    }
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase.from('Products').delete().eq('id', productId);
    } catch (e) {
      throw 'Error deleting product: $e';
    }
  }
}
