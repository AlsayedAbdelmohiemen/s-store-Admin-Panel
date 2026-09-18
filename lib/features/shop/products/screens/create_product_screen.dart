import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/products_controller.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Breadcrumb Header
            const SBreadcrumbWithHeading(
              heading: 'Create Product',
              breadcrumbItems: ['Products', 'New Product'],
              returnToPreviousScreen: true,
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Form Card
            Container(
              padding: const EdgeInsets.all(SSizes.defaultSpace * 1.5),
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
                    'Basic Information',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  /// Title
                  TextFormField(
                    controller: controller.title,
                    decoration: const InputDecoration(
                      labelText: 'Product Title',
                      prefixIcon: Icon(Iconsax.box),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),

                  /// Description
                  TextFormField(
                    controller: controller.description,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Pricing & Stock Row
                  Text(
                    'Pricing & Inventory',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Regular Price (\$)',
                            prefixIcon: Icon(Iconsax.dollar_circle),
                          ),
                        ),
                      ),
                      const SizedBox(width: SSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: controller.salePrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Sale Price (\$)',
                            prefixIcon: Icon(Iconsax.discount_shape),
                          ),
                        ),
                      ),
                      const SizedBox(width: SSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: controller.stock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock Quantity',
                            prefixIcon: Icon(Iconsax.archive_book),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Organization (Category & Brand)
                  Text(
                    'Categorization',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<CategoryModel>(
                            initialValue: controller.selectedCategory.value,
                            decoration: const InputDecoration(
                              labelText: 'Select Category',
                              prefixIcon: Icon(Iconsax.category),
                            ),
                            items: controller.categories.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat.name));
                            }).toList(),
                            onChanged: (cat) => controller.selectedCategory.value = cat,
                          ),
                        ),
                      ),
                      const SizedBox(width: SSizes.spaceBtwInputFields),
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<BrandModel>(
                            initialValue: controller.selectedBrand.value,
                            decoration: const InputDecoration(
                              labelText: 'Select Brand',
                              prefixIcon: Icon(Iconsax.tag),
                            ),
                            items: controller.brands.map((br) {
                              return DropdownMenuItem(value: br, child: Text(br.name));
                            }).toList(),
                            onChanged: (br) => controller.selectedBrand.value = br,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Media Thumbnail
                  Text(
                    'Product Thumbnail',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  TextFormField(
                    controller: controller.thumbnail,
                    decoration: const InputDecoration(
                      labelText: 'Thumbnail Image URL (from Media Center or external)',
                      prefixIcon: Icon(Iconsax.image),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  /// Featured Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Featured Product', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Show this product on home screen featured section', style: TextStyle(color: SColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isFeatured.value,
                          activeThumbColor: SColors.primary,
                          onChanged: (val) => controller.isFeatured.value = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections * 1.5),

                  /// Save Button
                  SizedBox(
                    width: 240,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: controller.isLoading.value ? null : () => controller.saveProduct(),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save & Publish Product', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
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
