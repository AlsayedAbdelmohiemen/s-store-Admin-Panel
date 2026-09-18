import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/customers_repository.dart';

class CustomersController extends GetxController {
  static CustomersController get instance => Get.find();

  final repository = Get.put(CustomersRepository());

  final allCustomers = <UserModel>[].obs;
  final filteredCustomers = <UserModel>[].obs;
  final isLoading = false.obs;
  final searchText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      final users = await repository.getAllCustomers();
      allCustomers.assignAll(users);
      filteredCustomers.assignAll(users);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch customers: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(allCustomers);
    } else {
      filteredCustomers.assignAll(
        allCustomers.where(
          (u) =>
              u.fullName.toLowerCase().contains(query.toLowerCase()) ||
              u.email.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> deleteCustomer(String userId) async {
    try {
      await repository.deleteCustomer(userId);
      allCustomers.removeWhere((u) => u.id == userId);
      searchCustomers(searchText.text);
      Get.snackbar(
        'Deleted',
        'Customer record removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete customer: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
