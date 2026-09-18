import 'package:get/get.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../utils/constants/enums.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final repository = Get.put(DashboardRepository());

  final isLoading = false.obs;
  final totalSales = 0.0.obs;
  final totalOrders = 0.obs;
  final avgOrderValue = 0.0.obs;
  final totalCustomers = 0.obs;

  final weeklySales = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final orderStatusData = <OrderStatus, int>{}.obs;
  final recentOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // 1. Fetch Metrics
      final metrics = await repository.getDashboardMetrics();
      totalSales.value = (metrics['totalSales'] as num?)?.toDouble() ?? 0.0;
      totalOrders.value = (metrics['totalOrders'] as num?)?.toInt() ?? 0;
      avgOrderValue.value = (metrics['avgOrderValue'] as num?)?.toDouble() ?? 0.0;
      totalCustomers.value = (metrics['totalCustomers'] as num?)?.toInt() ?? 0;

      // 2. Fetch Weekly Sales
      final sales = await repository.getWeeklySales();
      weeklySales.assignAll(sales);

      // 3. Fetch Status Counts
      final statusCounts = await repository.getOrderStatusCounts();
      orderStatusData.assignAll(statusCounts);

      // 4. Fetch Recent Orders
      final orders = await repository.getRecentOrders();
      recentOrders.assignAll(orders);
    } catch (_) {
      // Keep existing values or fallback gracefully
    } finally {
      isLoading.value = false;
    }
  }
}
