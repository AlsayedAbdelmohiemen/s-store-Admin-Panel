import 'brand_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
  });

  static ProductModel empty() => ProductModel(
        id: '',
        title: '',
        stock: 0,
        price: 0,
        thumbnail: '',
        productType: 'single',
      );

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured ?? false,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductModel.empty();
    return ProductModel(
      id: data['id']?.toString() ?? '',
      title: data['Title'] ?? data['title'] ?? '',
      stock: int.tryParse(data['Stock']?.toString() ?? '0') ?? 0,
      price: double.tryParse(data['Price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '0.0') ?? 0.0,
      thumbnail: data['Thumbnail'] ?? data['thumbnail'] ?? '',
      productType: data['ProductType'] ?? data['productType'] ?? 'single',
      sku: data['SKU'] ?? data['sku'] ?? '',
      description: data['Description'] ?? data['description'] ?? '',
      categoryId: data['CategoryId'] ?? data['categoryId'] ?? '',
      isFeatured: data['IsFeatured'] ?? data['isFeatured'] ?? false,
      brand: data['Brand'] != null ? BrandModel.fromJson(Map<String, dynamic>.from(data['Brand'])) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      date: data['Date'] != null ? DateTime.tryParse(data['Date'].toString()) : null,
    );
  }
}
