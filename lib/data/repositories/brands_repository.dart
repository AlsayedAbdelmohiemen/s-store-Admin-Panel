import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/brand_model.dart';

class BrandsRepository extends GetxController {
  static BrandsRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all brands
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final response = await _supabase.from('Brands').select();
      return (response as List).map((data) => BrandModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching brands: $e';
    }
  }

  /// Create new brand
  Future<BrandModel> createBrand(BrandModel brand) async {
    try {
      final response = await _supabase.from('Brands').insert({
        'Name': brand.name,
        'Image': brand.image,
        'ProductsCount': brand.productsCount ?? 0,
        'IsFeatured': brand.isFeatured ?? false,
      }).select().single();
      return BrandModel.fromJson(response);
    } catch (e) {
      throw 'Error creating brand: $e';
    }
  }

  /// Update brand
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await _supabase.from('Brands').update({
        'Name': brand.name,
        'Image': brand.image,
        'ProductsCount': brand.productsCount ?? 0,
        'IsFeatured': brand.isFeatured ?? false,
      }).eq('id', brand.id);
    } catch (e) {
      throw 'Error updating brand: $e';
    }
  }

  /// Delete brand
  Future<void> deleteBrand(String brandId) async {
    try {
      await _supabase.from('Brands').delete().eq('id', brandId);
    } catch (e) {
      throw 'Error deleting brand: $e';
    }
  }
}
