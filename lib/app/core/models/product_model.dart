class Product {
  final String id;
  final String name;
  final String image;
  final String? description;
  final double? price;
  final String? categoryId;
  final bool isSpecial;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // -- Fields added for UI --
  final double rating;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.price,
    this.categoryId,
    this.isSpecial = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    // Add rating and isFavorite to the constructor
    this.rating = 0.0, // Default to 0.0 if not provided
    this.isFavorite = false, // Default to false
  });

  // Factory constructor for creating Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'],
      price: json['price']?.toDouble(),
      categoryId: json['categoryId'],
      isSpecial: json['isSpecial'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      rating: json['rating']?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Method for converting Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'isSpecial': isSpecial,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }

  // CopyWith method for creating modified copies
  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    double? price,
    String? categoryId,
    bool? isSpecial,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      isSpecial: isSpecial ?? this.isSpecial,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Other methods remain the same
  @override
  String toString() {
    return 'Product{id: $id, name: $name, image: $image, price: $price, rating: $rating}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}