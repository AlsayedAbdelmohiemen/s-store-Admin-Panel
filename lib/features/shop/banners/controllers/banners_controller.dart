import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/banner_model.dart';
import '../../../../data/repositories/banners_repository.dart';

class BannersController extends GetxController {
  static BannersController get instance => Get.find();

  final repository = Get.put(BannersRepository());

  final allBanners = <BannerModel>[].obs;
  final filteredBanners = <BannerModel>[].obs;
  final isLoading = false.obs;
  final searchText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      final banners = await repository.getAllBanners();
      allBanners.assignAll(banners);
      filteredBanners.assignAll(banners);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch banners: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchBanners(String query) {
    if (query.isEmpty) {
      filteredBanners.assignAll(allBanners);
    } else {
      filteredBanners.assignAll(
        allBanners.where((b) => b.targetScreen.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> toggleActive(BannerModel banner, bool active) async {
    try {
      await repository.toggleBannerActive(banner.id, active);
      final index = allBanners.indexWhere((b) => b.id == banner.id);
      if (index != -1) {
        allBanners[index] = BannerModel(
          id: banner.id,
          imageUrl: banner.imageUrl,
          targetScreen: banner.targetScreen,
          active: active,
        );
        searchBanners(searchText.text);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> createBanner({required String imageUrl, required String targetScreen, required bool active}) async {
    try {
      isLoading.value = true;
      final newBanner = BannerModel(
        imageUrl: imageUrl,
        targetScreen: targetScreen,
        active: active,
      );
      final created = await repository.createBanner(newBanner);
      allBanners.add(created);
      searchBanners(searchText.text);
      Get.back();
      Get.snackbar(
        'Success',
        'Banner created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create banner: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBanner(String bannerId) async {
    try {
      await repository.deleteBanner(bannerId);
      allBanners.removeWhere((b) => b.id == bannerId);
      searchBanners(searchText.text);
      Get.snackbar(
        'Deleted',
        'Banner removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete banner: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
