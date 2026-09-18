class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  static CategoryModel empty() => CategoryModel(
        id: '',
        name: '',
        image: '',
        isFeatured: false,
      );

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> document) {
    return CategoryModel(
      id: document['id']?.toString() ?? '',
      name: document['Name'] ?? document['name'] ?? '',
      image: document['Image'] ?? document['image'] ?? '',
      parentId: document['ParentId'] ?? document['parentId'] ?? '',
      isFeatured: document['IsFeatured'] ?? document['isFeatured'] ?? false,
    );
  }
}
