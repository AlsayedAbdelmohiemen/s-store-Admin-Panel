import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class SBreadcrumbWithHeading extends StatelessWidget {
  const SBreadcrumbWithHeading({
    super.key,
    required this.heading,
    required this.breadcrumbItems,
    this.returnToPreviousScreen = false,
  });

  final String heading;
  final List<String> breadcrumbItems;
  final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Breadcrumbs Trail
        Row(
          children: [
            InkWell(
              onTap: () {},
              child: const Text('Dashboard', style: TextStyle(fontSize: 12, color: SColors.textSecondary)),
            ),
            for (int i = 0; i < breadcrumbItems.length; i++) ...[
              const Icon(Iconsax.arrow_right_3, size: 12, color: SColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                breadcrumbItems[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: i == breadcrumbItems.length - 1 ? FontWeight.w600 : FontWeight.normal,
                  color: i == breadcrumbItems.length - 1 ? SColors.primary : SColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: SSizes.sm),

        /// Page Heading
        Row(
          children: [
            if (returnToPreviousScreen) ...[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Iconsax.arrow_left),
              ),
              const SizedBox(width: SSizes.sm),
            ],
            Text(
              heading,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
