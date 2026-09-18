import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/constants/enums.dart';
import '../models/order_model.dart';

class OrdersRepository extends GetxController {
  static OrdersRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _supabase
          .from('Orders')
          .select()
          .order('orderDate', ascending: false);

      return (response as List).map((data) => OrderModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching orders: $e';
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _supabase.from('Orders').update({'status': status.name}).eq('id', orderId);
    } catch (e) {
      throw 'Error updating order status: $e';
    }
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _supabase.from('Orders').delete().eq('id', orderId);
    } catch (e) {
      throw 'Error deleting order: $e';
    }
  }
}
