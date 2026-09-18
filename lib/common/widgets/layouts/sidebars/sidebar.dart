import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../data/repositories/authentication_repository.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'sidebar_controller.dart';

class SSidebar extends StatelessWidget {
  const SSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(SidebarController());

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: dark ? SColors.darkContainer : SColors.white,
        border: Border(
          right: BorderSide(
            color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
          ),
        ),
      ),
      child: Column(
        children: [
          /// App Header / Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: SSizes.md, vertical: SSizes.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(SSizes.sm),
                  decoration: BoxDecoration(
                    color: SColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.shop, color: Colors.white, size: 24),
                ),
                const SizedBox(width: SSizes.spaceBtwItems / 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'S-Store',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ADMIN DASHBOARD',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: SColors.primary,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: SSizes.spaceBtwItems),

          /// Navigation Menu
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SidebarMenuItem(
                    icon: Iconsax.status,
                    title: 'Dashboard',
                    route: SRoutes.dashboard,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.image,
                    title: 'Media Center',
                    route: SRoutes.media,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.category_2,
                    title: 'Categories',
                    route: SRoutes.categories,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.dcube,
                    title: 'Brands',
                    route: SRoutes.brands,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.picture_frame,
                    title: 'Banners',
                    route: SRoutes.banners,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.box,
                    title: 'Products',
                    route: SRoutes.products,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.profile_2user,
                    title: 'Customers',
                    route: SRoutes.customers,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.box_tick,
                    title: 'Orders',
                    route: SRoutes.orders,
                    controller: controller,
                  ),
                  _SidebarMenuItem(
                    icon: Iconsax.setting_2,
                    title: 'Settings',
                    route: SRoutes.settings,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          /// Footer / Logout
          Padding(
            padding: const EdgeInsets.all(SSizes.md),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Iconsax.logout, color: SColors.error),
              title: const Text('Sign Out', style: TextStyle(color: SColors.error, fontWeight: FontWeight.w600)),
              onTap: () {
                Get.defaultDialog(
                  title: 'Sign Out',
                  middleText: 'Are you sure you want to sign out of the Admin Portal?',
                  textConfirm: 'Sign Out',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: SColors.error,
                  onConfirm: () {
                    Get.back();
                    AuthenticationRepository.instance.logout();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatelessWidget {
  const _SidebarMenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.controller,
  });

  final IconData icon;
  final String title;
  final String route;
  final SidebarController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.isActive(route);
      final isHovering = controller.isHovering(route);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: SSizes.sm, vertical: 3),
        child: InkWell(
          onTap: () => controller.menuOnTap(route),
          onHover: (hovering) => hovering
              ? controller.changeHoverItem(route)
              : controller.changeHoverItem(''),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: SSizes.md, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? SColors.primary
                  : isHovering
                      ? SColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? Colors.white
                      : isHovering
                          ? SColors.primary
                          : SColors.textSecondary,
                ),
                const SizedBox(width: SSizes.spaceBtwItems),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive
                        ? Colors.white
                        : isHovering
                            ? SColors.primary
                            : SColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
