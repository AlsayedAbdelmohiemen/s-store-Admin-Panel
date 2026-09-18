import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoriesRepository extends GetxController {
  static CategoriesRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _supabase.from('Categories').select();
      return (response as List).map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching categories: $e';
    }
  }

  /// Create new category
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await _supabase.from('Categories').insert({
        'Name': category.name,
        'Image': category.image,
        'ParentId': category.parentId,
        'IsFeatured': category.isFeatured,
      }).select().single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw 'Error creating category: $e';
    }
  }

  /// Update category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _supabase.from('Categories').update({
        'Name': category.name,
        'Image': category.image,
        'ParentId': category.parentId,
        'IsFeatured': category.isFeatured,
      }).eq('id', category.id);
    } catch (e) {
      throw 'Error updating category: $e';
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _supabase.from('Categories').delete().eq('id', categoryId);
    } catch (e) {
      throw 'Error deleting category: $e';
    }
  }
}
