import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes.dart';

class SRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
      return isAuthenticated ? null : const RouteSettings(name: SRoutes.login);
    } catch (_) {
      return const RouteSettings(name: SRoutes.login);
    }
  }
}
