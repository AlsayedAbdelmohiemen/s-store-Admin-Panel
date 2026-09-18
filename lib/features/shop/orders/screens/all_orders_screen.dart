import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../data/models/order_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/orders_controller.dart';

class AllOrdersScreen extends StatelessWidget {
  const AllOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    final statuses = ['All', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header & Breadcrumbs
            const SBreadcrumbWithHeading(
              heading: 'Orders',
              breadcrumbItems: ['Shop', 'Orders'],
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Filter Chips
            Obx(
              () => Wrap(
                spacing: 10,
                children: statuses.map((status) {
                  final isSelected = controller.selectedFilter.value.toLowerCase() == status.toLowerCase();
                  return ChoiceChip(
                    label: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isSelected ? Colors.white : (dark ? Colors.white70 : SColors.dark),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: SColors.primary,
                    backgroundColor: dark ? SColors.darkContainer : SColors.light,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onSelected: (_) => controller.filterOrders(status),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Orders Table Container
            Container(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              decoration: BoxDecoration(
                color: dark ? SColors.darkContainer : SColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                ),
              ),
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()));
                  }

                  if (controller.filteredOrders.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('No orders found matching the filter.', style: TextStyle(color: SColors.textSecondary)),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 500,
                    child: DataTable2(
                      columnSpacing: 16,
                      horizontalMargin: 12,
                      minWidth: 700,
                      columns: const [
                        DataColumn2(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                        DataColumn2(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn2(label: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                        DataColumn2(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn2(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                      ],
                      rows: controller.filteredOrders.map((order) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '#${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: SColors.primary),
                              ),
                            ),
                            DataCell(Text(order.formattedOrderDate)),
                            DataCell(Text('${order.items.length} Items')),
                            DataCell(
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(
                              DropdownButton<OrderStatus>(
                                value: order.status,
                                underline: const SizedBox.shrink(),
                                items: OrderStatus.values.map((s) {
                                  Color color = SColors.primary;
                                  if (s == OrderStatus.delivered) color = SColors.success;
                                  if (s == OrderStatus.processing) color = SColors.warning;
                                  if (s == OrderStatus.cancelled) color = SColors.error;

                                  return DropdownMenuItem(
                                    value: s,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        s.name.capitalizeFirst!,
                                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newStatus) {
                                  if (newStatus != null) {
                                    controller.updateStatus(order, newStatus);
                                  }
                                },
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Iconsax.eye, size: 18, color: SColors.primary),
                                    tooltip: 'View Order Details',
                                    onPressed: () => _showOrderDetailsDialog(context, order),
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, size: 18, color: SColors.error),
                                    tooltip: 'Delete Order',
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete Order',
                                        middleText: 'Are you sure you want to delete order #${order.id}?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteOrder(order.id);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, OrderModel order) {
    Get.defaultDialog(
      title: 'Order Details #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
      content: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${order.formattedOrderDate}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('Payment Method: ${order.paymentMethod}', style: const TextStyle(color: SColors.textSecondary)),
            const Divider(height: 24),
            const Text('Purchased Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x  ${item.title.isEmpty ? 'Product Item' : item.title}'),
                    Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: SColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
      textCancel: 'Close',
    );
  }
}
