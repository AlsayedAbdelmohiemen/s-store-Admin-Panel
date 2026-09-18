import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/media_repository.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  final repository = Get.put(MediaRepository());

  final selectedBucket = 'products'.obs;
  final mediaFiles = <FileObject>[].obs;
  final isLoading = false.obs;

  final buckets = ['products', 'banners', 'categories', 'brands'];

  @override
  void onInit() {
    super.onInit();
    fetchMediaFiles();
  }

  Future<void> fetchMediaFiles() async {
    try {
      isLoading.value = true;
      final files = await repository.listFiles(bucketName: selectedBucket.value);
      mediaFiles.assignAll(files.where((f) => !f.name.startsWith('.')).toList());
    } catch (e) {
      Get.snackbar('Media Error', 'Failed to fetch media files: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      isLoading.value = true;

      for (var file in result.files) {
        Uint8List? bytes = file.bytes;
        if (bytes == null && file.path != null) {
          // Fallback if desktop file path exists
          final ioFile = await file.xFile.readAsBytes();
          bytes = ioFile;
        }

        if (bytes != null) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name.replaceAll(' ', '_')}';
          await repository.uploadImageFile(
            bucketName: selectedBucket.value,
            path: fileName,
            fileBytes: bytes,
          );
        }
      }

      await fetchMediaFiles();

      Get.snackbar(
        'Upload Success',
        'Image(s) uploaded successfully to ${selectedBucket.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Upload Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void copyImageUrl(String fileName) {
    final publicUrl = repository.getPublicUrl(bucketName: selectedBucket.value, path: fileName);
    Clipboard.setData(ClipboardData(text: publicUrl));
    Get.snackbar(
      'Copied!',
      'Image URL copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> deleteMedia(String fileName) async {
    try {
      await repository.deleteFile(bucketName: selectedBucket.value, paths: [fileName]);
      mediaFiles.removeWhere((f) => f.name == fileName);
      Get.snackbar(
        'Deleted',
        'Image removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete image: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
