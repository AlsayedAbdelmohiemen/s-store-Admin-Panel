import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/repositories/categories_repository.dart';
import '../../../../utils/constants/colors.dart';

class CategoriesController extends GetxController {
  static CategoriesController get instance => Get.find();

  final repository = Get.put(CategoriesRepository());

  final allCategories = <CategoryModel>[].obs;
  final filteredCategories = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final searchText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await repository.getAllCategories();
      allCategories.assignAll(categories);
      filteredCategories.assignAll(categories);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      filteredCategories.assignAll(
        allCategories.where((c) => c.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> createCategory({required String name, required String image, required bool isFeatured, String parentId = ''}) async {
    try {
      isLoading.value = true;
      final newCategory = CategoryModel(
        id: '',
        name: name,
        image: image,
        isFeatured: isFeatured,
        parentId: parentId,
      );
      final created = await repository.createCategory(newCategory);
      allCategories.add(created);
      searchCategories(searchText.text);
      Get.back();
      Get.snackbar(
        'Success',
        'Category created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: SColors.success.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create category: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await repository.deleteCategory(categoryId);
      allCategories.removeWhere((c) => c.id == categoryId);
      searchCategories(searchText.text);
      Get.snackbar(
        'Deleted',
        'Category removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: SColors.error.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
