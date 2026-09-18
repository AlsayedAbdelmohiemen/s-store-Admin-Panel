import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Upload file bytes to Supabase Storage bucket
  Future<String> uploadImageFile({
    required String bucketName,
    required String path,
    required Uint8List fileBytes,
    String contentType = 'image/png',
  }) async {
    try {
      await _supabase.storage.from(bucketName).uploadBinary(
            path,
            fileBytes,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );

      final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw 'Error uploading file: $e';
    }
  }

  /// List all files in a bucket / path
  Future<List<FileObject>> listFiles({required String bucketName, String path = ''}) async {
    try {
      final List<FileObject> objects = await _supabase.storage.from(bucketName).list(path: path);
      return objects;
    } catch (e) {
      return [];
    }
  }

  /// Get Public URL
  String getPublicUrl({required String bucketName, required String path}) {
    return _supabase.storage.from(bucketName).getPublicUrl(path);
  }

  /// Delete file from bucket
  Future<void> deleteFile({required String bucketName, required List<String> paths}) async {
    try {
      await _supabase.storage.from(bucketName).remove(paths);
    } catch (e) {
      throw 'Error deleting file: $e';
    }
  }
}
