import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/brands_repository.dart';
import '../../../../data/repositories/categories_repository.dart';
import '../../../../data/repositories/products_repository.dart';
import '../../../../routes/routes.dart';

class ProductsController extends GetxController {
  static ProductsController get instance => Get.find();

  final repository = Get.put(ProductsRepository());
  final categoriesRepo = Get.put(CategoriesRepository());
  final brandsRepo = Get.put(BrandsRepository());

  final allProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final brands = <BrandModel>[].obs;

  final isLoading = false.obs;
  final searchText = TextEditingController();

  // Create Product Form Fields
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController(text: '0');
  final stock = TextEditingController(text: '10');
  final thumbnail = TextEditingController();
  final selectedCategory = Rxn<CategoryModel>();
  final selectedBrand = Rxn<BrandModel>();
  final isFeatured = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    loadCategoriesAndBrands();
  }

  Future<void> loadCategoriesAndBrands() async {
    try {
      final fetchedCategories = await categoriesRepo.getAllCategories();
      final fetchedBrands = await brandsRepo.getAllBrands();
      categories.assignAll(fetchedCategories);
      brands.assignAll(fetchedBrands);
      if (categories.isNotEmpty) selectedCategory.value = categories.first;
      if (brands.isNotEmpty) selectedBrand.value = brands.first;
    } catch (_) {}
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final products = await repository.getAllProducts();
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((p) => p.title.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> saveProduct() async {
    try {
      if (title.text.trim().isEmpty || price.text.trim().isEmpty) {
        Get.snackbar('Validation', 'Title and Price are required', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      isLoading.value = true;

      final newProduct = ProductModel(
        id: '',
        title: title.text.trim(),
        description: description.text.trim(),
        price: double.tryParse(price.text.trim()) ?? 0.0,
        salePrice: double.tryParse(salePrice.text.trim()) ?? 0.0,
        stock: int.tryParse(stock.text.trim()) ?? 0,
        thumbnail: thumbnail.text.trim(),
        productType: 'single',
        categoryId: selectedCategory.value?.id,
        brand: selectedBrand.value,
        isFeatured: isFeatured.value,
      );

      final created = await repository.createProduct(newProduct);
      allProducts.insert(0, created);
      searchProducts(searchText.text);

      // Clear fields
      title.clear();
      description.clear();
      price.clear();
      salePrice.text = '0';
      stock.text = '10';
      thumbnail.clear();

      Get.offNamed(SRoutes.products);
      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await repository.deleteProduct(productId);
      allProducts.removeWhere((p) => p.id == productId);
      searchProducts(searchText.text);
      Get.snackbar(
        'Deleted',
        'Product removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
