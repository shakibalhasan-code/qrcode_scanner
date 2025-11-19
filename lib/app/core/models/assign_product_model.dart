import '../api_endpoints.dart';

// User model for assigned product
class AssignProductUser {
  final String id;
  final String name;
  final String email;

  AssignProductUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AssignProductUser.fromJson(Map<String, dynamic> json) {
    return AssignProductUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

// Product details model for assigned product
class AssignedProductDetails {
  final String id;
  final String category;
  final String name;
  final String image;
  final String price;
  final String size;

  AssignedProductDetails({
    required this.id,
    required this.category,
    required this.name,
    required this.image,
    required this.price,
    required this.size,
  });

  factory AssignedProductDetails.fromJson(Map<String, dynamic> json) {
    return AssignedProductDetails(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '0',
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'name': name,
      'image': image,
      'price': price,
      'size': size,
    };
  }

  // Helper method to get complete image URL
  String getFullImageUrl() {
    if (image.startsWith('http')) {
      return image;
    }
    return '${ApiEndpoints.imageUrl}$image';
  }

  // Helper method to get formatted price
  String getFormattedPrice() {
    return '\$${price}';
  }
}

// Main assign product model
class AssignProduct {
  final String id;
  final AssignedProductDetails productId;
  final AssignProductUser userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignProduct({
    required this.id,
    required this.productId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignProduct.fromJson(Map<String, dynamic> json) {
    return AssignProduct(
      id: json['_id'] ?? '',
      productId: AssignedProductDetails.fromJson(json['productId'] ?? {}),
      userId: AssignProductUser.fromJson(json['userId'] ?? {}),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId.toJson(),
      'userId': userId.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Meta information for pagination
class AssignProductMeta {
  final int page;
  final int limit;
  final int total;

  AssignProductMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory AssignProductMeta.fromJson(Map<String, dynamic> json) {
    return AssignProductMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'total': total};
  }
}

// Data wrapper for assign products
class AssignProductData {
  final List<AssignProduct> assignProduct;
  final AssignProductMeta meta;

  AssignProductData({required this.assignProduct, required this.meta});

  factory AssignProductData.fromJson(Map<String, dynamic> json) {
    return AssignProductData(
      assignProduct:
          (json['assignProduct'] as List<dynamic>?)
              ?.map((item) => AssignProduct.fromJson(item))
              .toList() ??
          [],
      meta: AssignProductMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignProduct': assignProduct.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

// API Response wrapper for assign products
class AssignProductResponse {
  final bool success;
  final String message;
  final AssignProductData data;

  AssignProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AssignProductResponse.fromJson(Map<String, dynamic> json) {
    return AssignProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AssignProductData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
