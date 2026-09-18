import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/data/models/user_model.dart';
import 'package:admin_panel/data/models/order_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';

void main() {
  group('Customers & Orders Filtering Unit Tests', () {
    test('Filter customers by name or email matches search term', () {
      final customers = [
        UserModel(
          id: '1',
          firstName: 'Sayed',
          lastName: 'Hassan',
          username: 'sayed_h',
          email: 'sayed@example.com',
          phoneNumber: '0123456789',
          profilePicture: '',
        ),
        UserModel(
          id: '2',
          firstName: 'Omar',
          lastName: 'Ahmed',
          username: 'omar_a',
          email: 'omar@store.com',
          phoneNumber: '0987654321',
          profilePicture: '',
        ),
      ];

      final query = 'sayed'.toLowerCase();
      final filtered = customers.where((c) {
        return c.fullName.toLowerCase().contains(query) ||
            c.email.toLowerCase().contains(query);
      }).toList();

      expect(filtered.length, 1);
      expect(filtered.first.firstName, 'Sayed');
    });

    test('Filter orders by status works accurately', () {
      final orders = [
        OrderModel(
          id: 'ord_1',
          status: OrderStatus.delivered,
          items: [],
          totalAmount: 100.0,
          orderDate: DateTime.now(),
        ),
        OrderModel(
          id: 'ord_2',
          status: OrderStatus.pending,
          items: [],
          totalAmount: 50.0,
          orderDate: DateTime.now(),
        ),
        OrderModel(
          id: 'ord_3',
          status: OrderStatus.delivered,
          items: [],
          totalAmount: 200.0,
          orderDate: DateTime.now(),
        ),
      ];

      final deliveredOrders = orders
          .where((o) => o.status == OrderStatus.delivered)
          .toList();

      expect(deliveredOrders.length, 2);
      final totalDeliveredAmount = deliveredOrders.fold<double>(
          0.0, (sum, o) => sum + o.totalAmount);
      expect(totalDeliveredAmount, 300.0);
    });
  });
}
