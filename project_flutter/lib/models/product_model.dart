class ProductModel {
  final String id;
  String name;
  String brand;
  double price;
  double originalPrice;
  double rating;
  int reviewCount;
  String category;
  String description;
  List<String> specs;
  String iconPath;
  String imagePath; // asset image path
  int stock;
  bool isNew;
  bool isFeatured;
  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.description,
    required this.specs,
    required this.iconPath,
    this.imagePath = '',
    required this.stock,
    this.isNew = false,
    this.isFeatured = false,
    this.quantity = 1,
  });

  double get discount =>
      originalPrice > price ? ((originalPrice - price) / originalPrice * 100) : 0;

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? category,
    String? description,
    List<String>? specs,
    String? iconPath,
    String? imagePath,
    int? stock,
    bool? isNew,
    bool? isFeatured,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      description: description ?? this.description,
      specs: specs ?? this.specs,
      iconPath: iconPath ?? this.iconPath,
      imagePath: imagePath ?? this.imagePath,
      stock: stock ?? this.stock,
      isNew: isNew ?? this.isNew,
      isFeatured: isFeatured ?? this.isFeatured,
      quantity: quantity ?? this.quantity,
    );
  }
}
