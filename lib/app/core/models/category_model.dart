class Category {
  final String id;
  final String name;
  final String image;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Method for converting Category to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper method to get complete image URL
  String getFullImageUrl() {
    if (image.startsWith('http')) {
      return image;
    }
    return 'http://10.10.12.25:5008$image';
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

class CategoryMeta {
  final int page;
  final int total;

  CategoryMeta({required this.page, required this.total});

  factory CategoryMeta.fromJson(Map<String, dynamic> json) {
    return CategoryMeta(page: json['page'] ?? 1, total: json['total'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'total': total};
  }
}

class CategoryData {
  final List<Category> result;
  final CategoryMeta meta;

  CategoryData({required this.result, required this.meta});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      result:
          (json['result'] as List<dynamic>?)
              ?.map((item) => Category.fromJson(item))
              .toList() ??
          [],
      meta: CategoryMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((category) => category.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class CategoryResponse {
  final bool success;
  final String message;
  final CategoryData data;

  CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CategoryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
