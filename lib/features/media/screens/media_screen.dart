import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../common/widgets/layouts/site_layout.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/media_controller.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SSiteLayout(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Breadcrumbs & Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SBreadcrumbWithHeading(
                  heading: 'Media Center',
                  breadcrumbItems: ['Media', 'Storage Buckets'],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => controller.uploadImages(),
                  icon: const Icon(Iconsax.document_upload),
                  label: const Text('Upload Images', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Storage Bucket Filter Chips
            Obx(
              () => Wrap(
                spacing: 12,
                children: controller.buckets.map((bucket) {
                  final isSelected = controller.selectedBucket.value == bucket;
                  return ChoiceChip(
                    label: Text(
                      bucket.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : (dark ? Colors.white70 : SColors.dark),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: SColors.primary,
                    backgroundColor: dark ? SColors.darkContainer : SColors.light,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedBucket.value = bucket;
                        controller.fetchMediaFiles();
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Media Grid
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(60.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.mediaFiles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Column(
                        children: [
                          Icon(Iconsax.folder_open, size: 64, color: SColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No media files found in "${controller.selectedBucket.value}" bucket',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: SColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => controller.uploadImages(),
                            icon: const Icon(Iconsax.add),
                            label: const Text('Upload first image'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.mediaFiles.length,
                  itemBuilder: (context, index) {
                    final file = controller.mediaFiles[index];
                    final publicUrl = controller.repository.getPublicUrl(
                      bucketName: controller.selectedBucket.value,
                      path: file.name,
                    );

                    return Container(
                      decoration: BoxDecoration(
                        color: dark ? SColors.darkContainer : SColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              publicUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey.withValues(alpha: 0.1),
                                child: const Icon(Iconsax.image, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    file.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.copy, size: 16),
                                  tooltip: 'Copy Public URL',
                                  onPressed: () => controller.copyImageUrl(file.name),
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.trash, size: 16, color: Colors.red),
                                  tooltip: 'Delete Image',
                                  onPressed: () => controller.deleteMedia(file.name),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
