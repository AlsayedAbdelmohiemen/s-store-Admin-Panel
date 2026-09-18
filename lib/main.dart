import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'data/repositories/authentication_repository.dart';
import 'app.dart';

Future<void> main() async {
  // 1. Ensure widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Local Storage
  await GetStorage.init();

  // 3. Initialize Supabase Backend
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  // 4. Register Core Repositories
  Get.put(AuthenticationRepository());

  // 5. Run Admin Panel App
  runApp(const AdminApp());
}
