import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/brands_controller.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandsController());
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
                  heading: 'Brands',
                  breadcrumbItems: ['Shop', 'Brands'],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showCreateBrandDialog(context, controller),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Create Brand', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onChanged: (val) => controller.searchBrands(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search brand name...',
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
                            DataColumn2(label: Text('Brand Logo', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Products', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Featured', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                          ],
                          rows: controller.filteredBrands.map((brand) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: brand.image.startsWith('http')
                                        ? Image.network(
                                            brand.image,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 40,
                                              height: 40,
                                              color: SColors.darkGrey.withValues(alpha: 0.1),
                                              child: const Icon(Iconsax.tag, size: 20),
                                            ),
                                          )
                                        : Image.asset(
                                            brand.image.isNotEmpty ? brand.image : 'assets/icons/brands/nike.png',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 40,
                                              height: 40,
                                              color: SColors.darkGrey.withValues(alpha: 0.1),
                                              child: const Icon(Iconsax.tag, size: 20),
                                            ),
                                          ),
                                  ),
                                ),
                                DataCell(Text(brand.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text('${brand.productsCount ?? 0} Products')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (brand.isFeatured ?? false)
                                          ? SColors.success.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      (brand.isFeatured ?? false) ? 'Yes' : 'No',
                                      style: TextStyle(
                                        color: (brand.isFeatured ?? false) ? SColors.success : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete Brand',
                                        middleText: 'Are you sure you want to delete "${brand.name}"?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteBrand(brand.id);
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

  void _showCreateBrandDialog(BuildContext context, BrandsController controller) {
    final nameController = TextEditingController();
    final imageController = TextEditingController();
    final isFeatured = true.obs;

    Get.defaultDialog(
      title: 'Create New Brand',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                prefixIcon: Icon(Iconsax.tag),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Logo / Image URL',
                prefixIcon: Icon(Iconsax.image),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured Brand'),
                Obx(
                  () => Switch(
                    value: isFeatured.value,
                    activeThumbColor: SColors.primary,
                    onChanged: (val) => isFeatured.value = val,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      textConfirm: 'Save Brand',
      confirmTextColor: Colors.white,
      buttonColor: SColors.primary,
      onConfirm: () {
        if (nameController.text.trim().isEmpty) return;
        controller.createBrand(
          name: nameController.text.trim(),
          image: imageController.text.trim(),
          isFeatured: isFeatured.value,
        );
      },
    );
  }
}
