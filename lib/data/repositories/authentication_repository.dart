import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../routes/routes.dart';
import '../models/user_model.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  static SupabaseClient _supabase = Supabase.instance.client;

  /// Allows tests to inject a mock Supabase client.
  static void setSupabaseClient(SupabaseClient client) => _supabase = client;
  final _deviceStorage = GetStorage();

  User? get authUser => _supabase.auth.currentUser;
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  @override
  void onReady() {
    screenRedirect();
  }

  /// Redirect based on authentication state
  void screenRedirect() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      Get.offAllNamed(SRoutes.dashboard);
    } else {
      Get.offAllNamed(SRoutes.login);
    }
  }

  /// Login with email and password
  Future<AuthResponse> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return response;
    } catch (e) {
      throw 'Authentication failed: $e';
    }
  }

  /// Sign up / provision admin in Supabase Auth and assign admin role
  Future<AuthResponse> signUpAdmin(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      // After successful sign‑up, ensure the user has an admin role in the Users table
      final userId = response.user?.id;
      if (userId != null) {
        await _supabase.from('Users').upsert({
          'id': userId,
          'email': email.trim(),
          'role': 'admin',
        });
      }
      return response;
    } catch (e) {
      throw 'Registration failed: $e';
    }
  }

  /// Check if user has admin privileges
  Future<bool> checkIsAdmin(String userId) async {
    try {
      final data = await _supabase.from('Users').select().eq('id', userId).maybeSingle();
      if (data == null) return false; // No record → not admin
      final role = (data['Role'] ?? data['role'] ?? '').toString().toLowerCase();
      return role == 'admin';
    } catch (_) {
      // On error, treat as non‑admin for safety
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      _deviceStorage.remove('REMEMBER_ME_EMAIL');
      _deviceStorage.remove('REMEMBER_ME_PASSWORD');
      Get.offAllNamed(SRoutes.login);
    } catch (e) {
      throw 'Error signing out: $e';
    }
  }

  /// Get Current Admin Profile
  Future<UserModel> getAdminDetails() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return UserModel.empty();

      final data = await _supabase.from('Users').select().eq('id', user.id).maybeSingle();
      if (data != null) {
        return UserModel.fromJson(data);
      }
      return UserModel(
        id: user.id,
        firstName: 'Admin',
        lastName: 'User',
        username: user.email?.split('@').first ?? 'admin',
        email: user.email ?? '',
        phoneNumber: '',
        profilePicture: '',
        role: 'admin',
      );
    } catch (_) {
      return UserModel.empty();
    }
  }
}
