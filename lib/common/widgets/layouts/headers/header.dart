import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../data/repositories/authentication_repository.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../responsive/responsive_widget.dart';

class SHeader extends StatelessWidget implements PreferredSizeWidget {
  const SHeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: dark ? SColors.darkContainer : SColors.white,
        border: Border(
          bottom: BorderSide(
            color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: SSizes.md, vertical: SSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: !ResponsiveWidget.isDesktop(context)
            ? IconButton(
                onPressed: () {
                  if (scaffoldKey?.currentState != null) {
                    scaffoldKey!.currentState!.openDrawer();
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
                icon: const Icon(Iconsax.menu),
              )
            : null,
        title: ResponsiveWidget.isDesktop(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.search_normal),
                    hintText: 'Search anything in store...',
                    filled: true,
                    fillColor: dark ? SColors.dark : SColors.light,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: SSizes.md),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              )
            : null,
        actions: [
          /// Theme toggle
          IconButton(
            icon: Icon(dark ? Iconsax.sun_1 : Iconsax.moon),
            onPressed: () => Get.changeThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
          ),

          /// Notifications
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {},
          ),
          const SizedBox(width: SSizes.spaceBtwItems / 2),

          /// Admin Profile Info with Dropdown
          PopupMenuButton<String>(
            tooltip: 'Admin Account',
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'settings') {
                Get.toNamed(SRoutes.settings);
              } else if (value == 'logout') {
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
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Store Administrator', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('admin@sstore.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Iconsax.setting_2, size: 18),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Iconsax.logout, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: SColors.primary,
                  child: Icon(Iconsax.user, color: Colors.white, size: 20),
                ),
                if (ResponsiveWidget.isDesktop(context)) ...[
                  const SizedBox(width: SSizes.sm),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Admin',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'admin@sstore.com',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: SColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ],
            ),
          ),
          const SizedBox(width: SSizes.sm),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(SSizes.appBarHeight + 15);
}
