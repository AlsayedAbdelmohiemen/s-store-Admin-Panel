import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? SColors.dark : SColors.light,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Container(
            width: 460,
            padding: const EdgeInsets.all(SSizes.defaultSpace * 1.5),
            decoration: BoxDecoration(
              color: dark ? SColors.darkContainer : SColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// App Brand Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: SColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Iconsax.shield_security, color: SColors.primary, size: 28),
                      ),
                      const SizedBox(width: SSizes.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'S-Store Admin',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: SColors.primary,
                                ),
                          ),
                          Text(
                            'Management Portal',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: SColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Welcome title
                  Text(
                    'Welcome back 👋',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: SSizes.xs),
                  Text(
                    'Enter your admin credentials to access your store dashboard.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: SColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Email Field
                  Text(
                    'Email Address',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: SSizes.xs),
                  TextFormField(
                    controller: controller.email,
                    validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.direct_right),
                      hintText: 'admin@sstore.com',
                      filled: true,
                      fillColor: dark ? SColors.dark : SColors.light,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),

                  /// Password Field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: SSizes.xs),
                  Obx(
                    () => TextFormField(
                      controller: controller.password,
                      obscureText: controller.hidePassword.value,
                      validator: (val) => val == null || val.isEmpty ? 'Password is required' : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                          onPressed: () => controller.hidePassword.toggle(),
                        ),
                        hintText: '••••••••',
                        filled: true,
                        fillColor: dark ? SColors.dark : SColors.light,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  /// Remember Me & Forgot Password
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (val) => controller.rememberMe.value = val ?? false,
                              activeColor: SColors.primary,
                            ),
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Get.snackbar(
                            'Password Reset',
                            'Please contact system owner or check Supabase auth settings to reset password.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: controller.isLoading.value ? null : () => controller.login(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Sign In to Dashboard',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: SSizes.spaceBtwItems),

                  /// Quick Demo Login (No manual sign-up needed)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SColors.primary,
                        side: const BorderSide(color: SColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => controller.quickDemoLogin(),
                      icon: const Icon(Iconsax.flash_1, color: SColors.primary),
                      label: const Text(
                        '⚡ Quick Demo Admin Login (دخول تجريبي فوري)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// Info Banner explaining why there is no sign up
                  Container(
                    padding: const EdgeInsets.all(SSizes.md),
                    decoration: BoxDecoration(
                      color: dark ? SColors.dark : SColors.light,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dark ? SColors.darkerGrey.withValues(alpha: 0.2) : SColors.borderSecondary,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Iconsax.info_circle, size: 20, color: SColors.primary),
                        const SizedBox(width: SSizes.sm),
                        Expanded(
                          child: Text(
                            'Admin panels have no public Sign Up for security. Use "Quick Demo Admin Login" above, or create an Admin user in Supabase Console -> Auth -> Users.',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: SColors.textSecondary,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
