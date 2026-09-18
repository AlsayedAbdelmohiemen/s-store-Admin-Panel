import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/enums.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class SOrderStatusPieChart extends StatelessWidget {
  const SOrderStatusPieChart({super.key});

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
          Text(
            'Order Status Distribution',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: SSizes.spaceBtwSections),
          SizedBox(
            height: 180,
            child: Obx(
              () {
                final controller = Get.find<DashboardController>();
                final delivered = (controller.orderStatusData[OrderStatus.delivered] ?? 45).toDouble();
                final shipped = (controller.orderStatusData[OrderStatus.shipped] ?? 20).toDouble();
                final processing = (controller.orderStatusData[OrderStatus.processing] ?? 25).toDouble();
                final cancelled = (controller.orderStatusData[OrderStatus.cancelled] ?? 10).toDouble();
                final total = delivered + shipped + processing + cancelled;

                return PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 45,
                    sections: [
                      PieChartSectionData(
                        color: SColors.success,
                        value: delivered,
                        title: '${total > 0 ? ((delivered / total) * 100).toInt() : 0}%',
                        radius: 35,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      PieChartSectionData(
                        color: SColors.primary,
                        value: shipped,
                        title: '${total > 0 ? ((shipped / total) * 100).toInt() : 0}%',
                        radius: 35,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      PieChartSectionData(
                        color: SColors.warning,
                        value: processing,
                        title: '${total > 0 ? ((processing / total) * 100).toInt() : 0}%',
                        radius: 35,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      PieChartSectionData(
                        color: SColors.error,
                        value: cancelled,
                        title: '${total > 0 ? ((cancelled / total) * 100).toInt() : 0}%',
                        radius: 35,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: SSizes.md),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatusIndicator(color: SColors.success, text: 'Delivered'),
              _StatusIndicator(color: SColors.primary, text: 'Shipped'),
              _StatusIndicator(color: SColors.warning, text: 'Processing'),
              _StatusIndicator(color: SColors.error, text: 'Cancelled'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: SColors.textSecondary)),
      ],
    );
  }
}
