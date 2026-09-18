import 'package:get/get.dart';
import '../../../../routes/routes.dart';

class SidebarController extends GetxController {
  static SidebarController get instance => Get.find();

  final activeItem = SRoutes.dashboard.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;
  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (!isActive(route)) {
      changeActiveItem(route);
      Get.toNamed(route);
    }
  }
}
