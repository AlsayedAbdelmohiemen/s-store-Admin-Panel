import 'package:get/get.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/media/screens/media_screen.dart';
import '../features/shop/banners/screens/all_banners_screen.dart';
import '../features/shop/brands/screens/all_brands_screen.dart';
import '../features/shop/categories/screens/all_categories_screen.dart';
import '../features/shop/customers/screens/all_customers_screen.dart';
import '../features/shop/dashboard/screens/dashboard_screen.dart';
import '../features/shop/orders/screens/all_orders_screen.dart';
import '../features/shop/products/screens/all_products_screen.dart';
import '../features/shop/products/screens/create_product_screen.dart';
import '../features/shop/settings/screens/settings_screen.dart';
import 'routes.dart';
import 'routes_middleware.dart';

class SAppRoutes {
  static final List<GetPage> pages = [
    // 1. Authentication
    GetPage(name: SRoutes.login, page: () => const LoginScreen()),

    // 2. Dashboard
    GetPage(
      name: SRoutes.dashboard,
      page: () => const DashboardScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 3. Media Center
    GetPage(
      name: SRoutes.media,
      page: () => const MediaScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 4. Categories
    GetPage(
      name: SRoutes.categories,
      page: () => const AllCategoriesScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 5. Brands
    GetPage(
      name: SRoutes.brands,
      page: () => const AllBrandsScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 6. Banners
    GetPage(
      name: SRoutes.banners,
      page: () => const AllBannersScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 7. Products
    GetPage(
      name: SRoutes.products,
      page: () => const AllProductsScreen(),
      middlewares: [SRouteMiddleware()],
    ),
    GetPage(
      name: SRoutes.createProduct,
      page: () => const CreateProductScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 8. Customers
    GetPage(
      name: SRoutes.customers,
      page: () => const AllCustomersScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 9. Orders
    GetPage(
      name: SRoutes.orders,
      page: () => const AllOrdersScreen(),
      middlewares: [SRouteMiddleware()],
    ),

    // 10. Settings
    GetPage(
      name: SRoutes.settings,
      page: () => const SettingsScreen(),
      middlewares: [SRouteMiddleware()],
    ),
  ];
}
