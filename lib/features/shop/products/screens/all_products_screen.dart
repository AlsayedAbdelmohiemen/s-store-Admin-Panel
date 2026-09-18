import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/products_controller.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
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
                  heading: 'Products',
                  breadcrumbItems: ['Shop', 'Products'],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Get.toNamed(SRoutes.createProduct),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onChanged: (val) => controller.searchProducts(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search product title...',
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
                        height: 480,
                        child: DataTable2(
                          columnSpacing: 16,
                          horizontalMargin: 12,
                          minWidth: 750,
                          columns: const [
                            DataColumn2(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.L),
                            DataColumn2(label: Text('Brand', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn2(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn2(label: Text('Featured', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                          ],
                          rows: controller.filteredProducts.map((product) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.thumbnail,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 44,
                                            height: 44,
                                            color: Colors.grey.withValues(alpha: 0.2),
                                            child: const Icon(Iconsax.box, size: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(product.brand?.name ?? '-')),
                                DataCell(Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: product.stock > 0
                                          ? SColors.success.withValues(alpha: 0.1)
                                          : SColors.error.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${product.stock} in stock',
                                      style: TextStyle(
                                        color: product.stock > 0 ? SColors.success : SColors.error,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (product.isFeatured ?? false) ? '⭐ Yes' : 'No',
                                    style: TextStyle(
                                      color: (product.isFeatured ?? false) ? SColors.secondary : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.red, size: 18),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete Product',
                                        middleText: 'Are you sure you want to delete "${product.title}"?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteProduct(product.id);
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
}
