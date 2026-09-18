import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../common/widgets/layouts/site_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final storage = GetStorage();

  late final TextEditingController storeName;
  late final TextEditingController supportEmail;
  late final TextEditingController shippingFee;
  late final TextEditingController taxRate;

  @override
  void initState() {
    super.initState();
    storeName = TextEditingController(text: storage.read('STORE_NAME') ?? 'S-Store Online');
    supportEmail = TextEditingController(text: storage.read('SUPPORT_EMAIL') ?? 'support@sstore.com');
    shippingFee = TextEditingController(text: storage.read('SHIPPING_FEE') ?? '10.00');
    taxRate = TextEditingController(text: storage.read('TAX_RATE') ?? '5.0');
  }

  void saveSettings() {
    storage.write('STORE_NAME', storeName.text.trim());
    storage.write('SUPPORT_EMAIL', supportEmail.text.trim());
    storage.write('SHIPPING_FEE', shippingFee.text.trim());
    storage.write('TAX_RATE', taxRate.text.trim());

    Get.snackbar(
      'Saved',
      'Store settings updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: SColors.success.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header & Breadcrumbs
            const SBreadcrumbWithHeading(
              heading: 'Store Settings',
              breadcrumbItems: ['Administration', 'Settings'],
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Settings Card
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
                    'General Store Settings',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: storeName,
                          decoration: const InputDecoration(
                            labelText: 'Store Name',
                            prefixIcon: Icon(Iconsax.shop),
                          ),
                        ),
                      ),
                      const SizedBox(width: SSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: supportEmail,
                          decoration: const InputDecoration(
                            labelText: 'Support Contact Email',
                            prefixIcon: Icon(Iconsax.sms),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  Text(
                    'Shipping & Checkout Rates',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: shippingFee,
                          decoration: const InputDecoration(
                            labelText: 'Standard Shipping Fee (\$)',
                            prefixIcon: Icon(Iconsax.truck),
                          ),
                        ),
                      ),
                      const SizedBox(width: SSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: taxRate,
                          decoration: const InputDecoration(
                            labelText: 'Tax Rate (%)',
                            prefixIcon: Icon(Iconsax.percentage_circle),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections * 1.5),

                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: saveSettings,
                      child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
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
