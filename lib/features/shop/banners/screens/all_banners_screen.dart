import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/banners_controller.dart';

class AllBannersScreen extends StatelessWidget {
  const AllBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannersController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header & Breadcrumbs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SBreadcrumbWithHeading(
                  heading: 'Banners',
                  breadcrumbItems: ['Shop', 'Banners'],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showCreateBannerDialog(context, controller),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Create Banner', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Search & Table Container
            Container(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
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
                  /// Search input
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: controller.searchText,
                      onChanged: (val) => controller.searchBanners(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search banner target...',
                        filled: true,
                        fillColor: dark ? SColors.dark : SColors.light,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: SSizes.md),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Data Table
                  Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()));
                      }

                      return SizedBox(
                        height: 400,
                        child: DataTable2(
                          columnSpacing: 16,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: const [
                            DataColumn2(label: Text('Banner', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.L),
                            DataColumn2(label: Text('Target Screen', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                          ],
                          rows: controller.filteredBanners.map((banner) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          banner.imageUrl,
                                          width: 90,
                                          height: 45,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 90,
                                            height: 45,
                                            color: Colors.grey.withValues(alpha: 0.2),
                                            child: const Icon(Iconsax.image, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(banner.targetScreen, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(
                                  Switch(
                                    value: banner.active,
                                    activeThumbColor: SColors.primary,
                                    onChanged: (val) => controller.toggleActive(banner, val),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete Banner',
                                        middleText: 'Are you sure you want to delete this banner?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteBanner(banner.id);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBannerDialog(BuildContext context, BannersController controller) {
    final imageController = TextEditingController();
    final targetController = TextEditingController(text: '/cart');
    final active = true.obs;

    Get.defaultDialog(
      title: 'Create New Banner',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Iconsax.link),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Screen (e.g. /cart, /order)',
                prefixIcon: Icon(Iconsax.routing),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Status'),
                Obx(
                  () => Switch(
                    value: active.value,
                    activeThumbColor: SColors.primary,
                    onChanged: (val) => active.value = val,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      textConfirm: 'Save Banner',
      confirmTextColor: Colors.white,
      buttonColor: SColors.primary,
      onConfirm: () {
        if (imageController.text.trim().isEmpty) return;
        controller.createBanner(
          imageUrl: imageController.text.trim(),
          targetScreen: targetController.text.trim(),
          active: active.value,
        );
      },
    );
  }
}
