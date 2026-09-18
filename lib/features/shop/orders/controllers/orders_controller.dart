import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/orders_repository.dart';
import '../../../../utils/constants/enums.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final repository = Get.put(OrdersRepository());

  final allOrders = <OrderModel>[].obs;
  final filteredOrders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final orders = await repository.getAllOrders();
      allOrders.assignAll(orders);
      filterOrders(selectedFilter.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders(String status) {
    selectedFilter.value = status;
    if (status == 'All') {
      filteredOrders.assignAll(allOrders);
    } else {
      filteredOrders.assignAll(
        allOrders.where((o) => o.status.name.toLowerCase() == status.toLowerCase()),
      );
    }
  }

  Future<void> updateStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      await repository.updateOrderStatus(order.id, newStatus);
      final index = allOrders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        allOrders[index] = OrderModel(
          id: order.id,
          userId: order.userId,
          status: newStatus,
          totalAmount: order.totalAmount,
          orderDate: order.orderDate,
          paymentMethod: order.paymentMethod,
          address: order.address,
          deliveryDate: order.deliveryDate,
          items: order.items,
        );
        filterOrders(selectedFilter.value);
      }
      Get.snackbar(
        'Updated',
        'Order status changed to ${newStatus.name}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await repository.deleteOrder(orderId);
      allOrders.removeWhere((o) => o.id == orderId);
      filterOrders(selectedFilter.value);
      Get.snackbar(
        'Deleted',
        'Order removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
