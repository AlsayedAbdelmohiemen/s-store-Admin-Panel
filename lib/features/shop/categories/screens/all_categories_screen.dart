import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/categories_controller.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());
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
                  heading: 'Categories',
                  breadcrumbItems: ['Shop', 'Categories'],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showCreateCategoryDialog(context, controller),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Create Category', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onChanged: (val) => controller.searchCategories(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search category name...',
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
                            DataColumn2(label: Text('Icon / Image', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Parent', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Featured', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                          ],
                          rows: controller.filteredCategories.map((category) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      category.image,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        child: const Icon(Iconsax.category, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(category.parentId.isEmpty ? 'Root' : category.parentId)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: category.isFeatured
                                          ? SColors.success.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      category.isFeatured ? 'Yes' : 'No',
                                      style: TextStyle(
                                        color: category.isFeatured ? SColors.success : Colors.grey,
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
                                        title: 'Delete Category',
                                        middleText: 'Are you sure you want to delete "${category.name}"?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteCategory(category.id);
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

  void _showCreateCategoryDialog(BuildContext context, CategoriesController controller) {
    final nameController = TextEditingController();
    final imageController = TextEditingController();
    final isFeatured = true.obs;

    Get.defaultDialog(
      title: 'Create New Category',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                prefixIcon: Icon(Iconsax.category),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image / Icon URL',
                prefixIcon: Icon(Iconsax.image),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured Category'),
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
      textConfirm: 'Save Category',
      confirmTextColor: Colors.white,
      buttonColor: SColors.primary,
      onConfirm: () {
        if (nameController.text.trim().isEmpty) return;
        controller.createCategory(
          name: nameController.text.trim(),
          image: imageController.text.trim(),
          isFeatured: isFeatured.value,
        );
      },
    );
  }
}
