import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/data/models/order_model.dart';
import 'package:admin_panel/data/models/cart_item_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';

void main() {
  group('OrderModel & Dashboard Data Unit Tests', () {
    test('OrderModel.fromJson correctly parses order data and status', () {
      final json = {
        'id': 'ord_1001',
        'userId': 'usr_500',
        'status': 'delivered',
        'totalAmount': 299.99,
        'orderDate': '2026-09-15T10:30:00.000Z',
        'paymentMethod': 'Credit Card',
        'items': [
          {
            'productId': 'prod_1',
            'title': 'Nike Air Max',
            'price': 149.99,
            'quantity': 2,
          }
        ],
      };

      final order = OrderModel.fromJson(json);

      expect(order.id, 'ord_1001');
      expect(order.userId, 'usr_500');
      expect(order.status, OrderStatus.delivered);
      expect(order.orderStatusText, 'Delivered');
      expect(order.totalAmount, 299.99);
      expect(order.paymentMethod, 'Credit Card');
      expect(order.items.length, 1);
      expect(order.items.first.title, 'Nike Air Max');
    });

    test('OrderModel default fallback status is processing', () {
      final json = {
        'id': 'ord_1002',
        'totalAmount': 50.0,
        'status': 'unknown_status',
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
      expect(order.orderStatusText, 'Processing');
    });

    test('OrderModel.toJson serializes all fields correctly', () {
      final order = OrderModel(
        id: 'ord_1003',
        userId: 'usr_700',
        status: OrderStatus.shipped,
        totalAmount: 120.0,
        orderDate: DateTime(2026, 9, 15),
        items: [
          CartItemModel(
            productId: 'p2',
            title: 'Adidas Hoodie',
            price: 60.0,
            quantity: 2,
          ),
        ],
      );

      final json = order.toJson();
      expect(json['id'], 'ord_1003');
      expect(json['status'], 'shipped');
      expect(json['totalAmount'], 120.0);
      expect((json['items'] as List).length, 1);
    });
  });
}
