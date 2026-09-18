import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../controllers/customers_controller.dart';

class AllCustomersScreen extends StatelessWidget {
  const AllCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomersController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header & Breadcrumbs
            const SBreadcrumbWithHeading(
              heading: 'Customers',
              breadcrumbItems: ['Shop', 'Customers'],
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
                      onChanged: (val) => controller.searchCustomers(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search customer by name or email...',
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
                          minWidth: 700,
                          columns: const [
                            DataColumn2(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.L),
                            DataColumn2(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn2(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                            DataColumn2(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.S),
                          ],
                          rows: controller.filteredCustomers.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: SColors.primary.withValues(alpha: 0.1),
                                        child: Text(
                                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: SColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        user.fullName.isNotEmpty ? user.fullName : 'Customer',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(user.email.isNotEmpty ? user.email : '-')),
                                DataCell(Text(user.phoneNumber.isNotEmpty ? user.phoneNumber : '-')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: user.role == 'admin'
                                          ? SColors.primary.withValues(alpha: 0.1)
                                          : SColors.darkGrey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: TextStyle(
                                        color: user.role == 'admin' ? SColors.primary : SColors.darkGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: SColors.error, size: 18),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Delete Customer',
                                        middleText: 'Are you sure you want to remove customer "${user.fullName}"?',
                                        textConfirm: 'Delete',
                                        confirmTextColor: Colors.white,
                                        buttonColor: SColors.error,
                                        onConfirm: () {
                                          Get.back();
                                          controller.deleteCustomer(user.id);
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
