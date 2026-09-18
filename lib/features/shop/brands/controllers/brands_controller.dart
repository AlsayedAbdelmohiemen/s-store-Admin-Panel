import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/repositories/brands_repository.dart';
import '../../../../utils/constants/colors.dart';

class BrandsController extends GetxController {
  static BrandsController get instance => Get.find();

  final repository = Get.put(BrandsRepository());

  final allBrands = <BrandModel>[].obs;
  final filteredBrands = <BrandModel>[].obs;
  final isLoading = false.obs;
  final searchText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      isLoading.value = true;
      final brands = await repository.getAllBrands();
      allBrands.assignAll(brands);
      filteredBrands.assignAll(brands);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch brands: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchBrands(String query) {
    if (query.isEmpty) {
      filteredBrands.assignAll(allBrands);
    } else {
      filteredBrands.assignAll(
        allBrands.where((b) => b.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> createBrand({required String name, required String image, required bool isFeatured, int productsCount = 0}) async {
    try {
      isLoading.value = true;
      final newBrand = BrandModel(
        id: '',
        name: name,
        image: image,
        isFeatured: isFeatured,
        productsCount: productsCount,
      );
      final created = await repository.createBrand(newBrand);
      allBrands.add(created);
      searchBrands(searchText.text);
      Get.back();
      Get.snackbar(
        'Success',
        'Brand created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: SColors.success.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create brand: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      await repository.deleteBrand(brandId);
      allBrands.removeWhere((b) => b.id == brandId);
      searchBrands(searchText.text);
      Get.snackbar(
        'Deleted',
        'Brand removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: SColors.error.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete brand: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
