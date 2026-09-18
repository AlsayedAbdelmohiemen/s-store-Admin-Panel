import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../common/widgets/responsive/responsive_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_pie_chart.dart';
import '../widgets/recent_orders_table.dart';
import '../widgets/weekly_sales_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SSiteLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading & Breadcrumbs
              const SBreadcrumbWithHeading(
                heading: 'Store Dashboard',
                breadcrumbItems: ['Overview'],
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// KPI Summary Cards (Responsive Grid)
              const _KPICardsSection(),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// Analytics Charts (Sales Chart & Orders Pie Chart)
              const _ChartsSection(),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// Recent Orders Data Table
              const SRecentOrdersTable(),
            ],
          ),
        ),
      ),
    );
  }
}

class _KPICardsSection extends StatelessWidget {
  const _KPICardsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Obx(
      () {
        final salesStr = '\$${controller.totalSales.value.toStringAsFixed(2)}';
        final ordersStr = controller.totalOrders.value.toString();
        final aovStr = '\$${controller.avgOrderValue.value.toStringAsFixed(2)}';
        final customersStr = controller.totalCustomers.value.toString();

        return ResponsiveWidget(
          desktop: Row(
            children: [
              Expanded(child: SDashboardCard(title: 'Total Sales', subTitle: salesStr, stats: '+18.2%', icon: Iconsax.moneys, color: SColors.primary)),
              const SizedBox(width: SSizes.spaceBtwItems),
              Expanded(child: SDashboardCard(title: 'Total Orders', subTitle: ordersStr, stats: '+8.4%', icon: Iconsax.box, color: SColors.warning)),
              const SizedBox(width: SSizes.spaceBtwItems),
              Expanded(child: SDashboardCard(title: 'Average Order Value', subTitle: aovStr, stats: '+4.1%', icon: Iconsax.wallet_money, color: SColors.success)),
              const SizedBox(width: SSizes.spaceBtwItems),
              Expanded(child: SDashboardCard(title: 'Total Customers', subTitle: customersStr, stats: '+14.6%', icon: Iconsax.profile_2user, color: SColors.info)),
            ],
          ),
          tablet: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SDashboardCard(title: 'Total Sales', subTitle: salesStr, stats: '+18.2%', icon: Iconsax.moneys, color: SColors.primary)),
                  const SizedBox(width: SSizes.spaceBtwItems),
                  Expanded(child: SDashboardCard(title: 'Total Orders', subTitle: ordersStr, stats: '+8.4%', icon: Iconsax.box, color: SColors.warning)),
                ],
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(child: SDashboardCard(title: 'Average Order Value', subTitle: aovStr, stats: '+4.1%', icon: Iconsax.wallet_money, color: SColors.success)),
                  const SizedBox(width: SSizes.spaceBtwItems),
                  Expanded(child: SDashboardCard(title: 'Total Customers', subTitle: customersStr, stats: '+14.6%', icon: Iconsax.profile_2user, color: SColors.info)),
                ],
              ),
            ],
          ),
          mobile: Column(
            children: [
              SDashboardCard(title: 'Total Sales', subTitle: salesStr, stats: '+18.2%', icon: Iconsax.moneys, color: SColors.primary),
              const SizedBox(height: SSizes.spaceBtwItems),
              SDashboardCard(title: 'Total Orders', subTitle: ordersStr, stats: '+8.4%', icon: Iconsax.box, color: SColors.warning),
              const SizedBox(height: SSizes.spaceBtwItems),
              SDashboardCard(title: 'Average Order Value', subTitle: aovStr, stats: '+4.1%', icon: Iconsax.wallet_money, color: SColors.success),
              const SizedBox(height: SSizes.spaceBtwItems),
              SDashboardCard(title: 'Total Customers', subTitle: customersStr, stats: '+14.6%', icon: Iconsax.profile_2user, color: SColors.info),
            ],
          ),
        );
      },
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection();

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isDesktop(context)) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: SWeeklySalesChart()),
          SizedBox(width: SSizes.spaceBtwItems),
          Expanded(flex: 1, child: SOrderStatusPieChart()),
        ],
      );
    } else {
      return const Column(
        children: [
          SWeeklySalesChart(),
          SizedBox(height: SSizes.spaceBtwItems),
          SOrderStatusPieChart(),
        ],
      );
    }
  }
}
