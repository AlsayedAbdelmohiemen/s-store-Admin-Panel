import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class CustomersRepository extends GetxController {
  static CustomersRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all users / customers
  Future<List<UserModel>> getAllCustomers() async {
    try {
      final response = await _supabase.from('Users').select();
      return (response as List).map((data) => UserModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching customers: $e';
    }
  }

  /// Delete customer
  Future<void> deleteCustomer(String userId) async {
    try {
      await _supabase.from('Users').delete().eq('id', userId);
    } catch (e) {
      throw 'Error deleting customer: $e';
    }
  }
}
