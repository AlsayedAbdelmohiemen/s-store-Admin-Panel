class BrandModel {
  String id;
  String name;
  String image;
  bool? isFeatured;
  int? productsCount;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured,
    this.productsCount,
  });

  static BrandModel empty() => BrandModel(id: '', image: '', name: '');

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'Id': id,
      'Name': name,
      'Image': image,
      'ProductsCount': productsCount ?? 0,
      'IsFeatured': isFeatured ?? false,
    };
  }

  factory BrandModel.fromJson(Map<String, dynamic> data) {
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: data['Id']?.toString() ?? data['id']?.toString() ?? '',
      name: data['Name'] ?? data['name'] ?? '',
      image: data['Image'] ?? data['image'] ?? '',
      isFeatured: data['IsFeatured'] ?? data['isFeatured'] ?? false,
      productsCount: int.tryParse(data['ProductsCount']?.toString() ?? '0') ?? 0,
    );
  }
}
