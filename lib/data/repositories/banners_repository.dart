import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/banner_model.dart';

class BannersRepository extends GetxController {
  static BannersRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Fetch all banners from Supabase
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final response = await _supabase.from('Banners').select();
      return (response as List).map((data) => BannerModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Error fetching banners: $e';
    }
  }

  /// Create new banner
  Future<BannerModel> createBanner(BannerModel banner) async {
    try {
      final response = await _supabase.from('Banners').insert({
        'ImageUrl': banner.imageUrl,
        'TargetScreen': banner.targetScreen,
        'Active': banner.active,
      }).select().single();
      return BannerModel.fromJson(response);
    } catch (e) {
      throw 'Error creating banner: $e';
    }
  }

  /// Update banner
  Future<void> updateBanner(BannerModel banner) async {
    try {
      await _supabase.from('Banners').update({
        'ImageUrl': banner.imageUrl,
        'TargetScreen': banner.targetScreen,
        'Active': banner.active,
      }).eq('id', banner.id);
    } catch (e) {
      throw 'Error updating banner: $e';
    }
  }

  /// Toggle banner active status
  Future<void> toggleBannerActive(String bannerId, bool active) async {
    try {
      await _supabase.from('Banners').update({'Active': active}).eq('id', bannerId);
    } catch (e) {
      throw 'Error updating status: $e';
    }
  }

  /// Delete banner
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _supabase.from('Banners').delete().eq('id', bannerId);
    } catch (e) {
      throw 'Error deleting banner: $e';
    }
  }
}
