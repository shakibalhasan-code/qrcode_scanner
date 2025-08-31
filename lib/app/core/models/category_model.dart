class Category {
  final String id;
  final String name;
  final String image;
  final String? description;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.isActive = true,
  });

  // Factory constructor for creating Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  // Method for converting Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'isActive': isActive,
    };
  }

  // CopyWith method for creating modified copies
  Category copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    bool? isActive,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, image: $image, description: $description, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
