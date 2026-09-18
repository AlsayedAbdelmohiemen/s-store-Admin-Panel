import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class SDashboardCard extends StatelessWidget {
  const SDashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color = SColors.primary,
    this.isPositive = true,
  });

  final String title;
  final String subTitle;
  final String stats;
  final IconData icon;
  final Color color;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(SSizes.lg),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: SColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: SSizes.sm),

          /// Value
          Text(
            subTitle,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SSizes.sm),

          /// Percentage stats
          Row(
            children: [
              Icon(
                isPositive ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                color: isPositive ? SColors.success : SColors.error,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '$stats ',
                style: TextStyle(
                  color: isPositive ? SColors.success : SColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Text(
                'vs last month',
                style: TextStyle(color: SColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
