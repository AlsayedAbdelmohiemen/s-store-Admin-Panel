import 'package:intl/intl.dart';
import '../../utils/constants/enums.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final Map<String, dynamic>? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
  });

  String get formattedOrderDate => DateFormat('dd MMM yyyy').format(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? DateFormat('dd MMM yyyy').format(deliveryDate!)
      : '';

  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'address': address,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id']?.toString() ?? data['Id']?.toString() ?? '',
      userId: data['userId']?.toString() ?? data['UserId']?.toString() ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (data['status'] ?? '').toString().toLowerCase(),
        orElse: () => OrderStatus.processing,
      ),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: data['orderDate'] != null
          ? DateTime.tryParse(data['orderDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paymentMethod: data['paymentMethod'] ?? 'Paypal',
      address: data['address'] != null ? Map<String, dynamic>.from(data['address']) : null,
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.tryParse(data['deliveryDate'].toString())
          : null,
      items: data['items'] != null
          ? (data['items'] as List<dynamic>)
              .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : [],
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel.fromMap(json);
}
