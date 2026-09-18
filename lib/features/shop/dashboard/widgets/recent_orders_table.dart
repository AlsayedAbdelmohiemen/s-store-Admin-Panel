import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class SRecentOrdersTable extends StatelessWidget {
  const SRecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(SSizes.lg),
      decoration: BoxDecoration(
        color: dark ? SColors.darkContainer : SColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Store Orders',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Get.toNamed(SRoutes.orders),
                child: const Text('View All Orders'),
              ),
            ],
          ),
          const SizedBox(height: SSizes.md),
          SizedBox(
            height: 320,
            child: Obx(
              () {
                final controller = Get.find<DashboardController>();
                final orders = controller.recentOrders;

                if (orders.isEmpty) {
                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: const [
                      DataColumn2(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                      DataColumn2(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn2(label: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                      DataColumn2(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn2(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    ],
                    rows: [
                      _buildRow('#ORD-9421', '12 Sep 2026', '3 Items', 'Delivered', SColors.success, '\$240.00'),
                      _buildRow('#ORD-9420', '12 Sep 2026', '1 Item', 'Processing', SColors.warning, '\$85.50'),
                      _buildRow('#ORD-9419', '11 Sep 2026', '2 Items', 'Shipped', SColors.primary, '\$160.00'),
                      _buildRow('#ORD-9418', '11 Sep 2026', '5 Items', 'Delivered', SColors.success, '\$420.00'),
                      _buildRow('#ORD-9417', '10 Sep 2026', '1 Item', 'Cancelled', SColors.error, '\$65.00'),
                    ],
                  );
                }

                return DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: const [
                    DataColumn2(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                    DataColumn2(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn2(label: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                    DataColumn2(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn2(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                  ],
                  rows: orders.map((order) {
                    Color statusColor = SColors.primary;
                    if (order.status == OrderStatus.delivered) statusColor = SColors.success;
                    if (order.status == OrderStatus.processing) statusColor = SColors.warning;
                    if (order.status == OrderStatus.cancelled) statusColor = SColors.error;

                    return _buildRow(
                      '#${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                      order.formattedOrderDate,
                      '${order.items.length} Items',
                      order.orderStatusText,
                      statusColor,
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(String id, String date, String items, String status, Color statusColor, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: SColors.primary))),
        DataCell(Text(date)),
        DataCell(Text(items)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }
}
