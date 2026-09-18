class SRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const media = '/media';
  static const banners = '/banners';
  static const products = '/products';
  static const createProduct = '/create-product';
  static const editProduct = '/edit-product';
  static const categories = '/categories';
  static const createCategory = '/create-category';
  static const brands = '/brands';
  static const createBrand = '/create-brand';
  static const customers = '/customers';
  static const orders = '/orders';
  static const settings = '/settings';

  static const List<String> sidebarMenuItems = [
    dashboard,
    media,
    categories,
    brands,
    banners,
    products,
    customers,
    orders,
    settings,
  ];
}
