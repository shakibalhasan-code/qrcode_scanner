import '../api_endpoints.dart';

// User model for assigned product
class AssignProductUser {
  final String id;
  final String name;
  final String email;
  final String? image;

  AssignProductUser({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory AssignProductUser.fromJson(Map<String, dynamic> json) {
    return AssignProductUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      if (image != null) 'image': image,
    };
  }

  // Helper method to get complete image URL
  String getFullImageUrl() {
    if (image == null || image!.isEmpty) return '';
    if (image!.startsWith('http')) {
      return image!;
    }
    final baseUrl = ApiEndpoints.imageBaseUrl;
    final imagePath = image!.startsWith('/') ? image! : '/$image';
    return '$baseUrl$imagePath';
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
  final String? status;
  final String? qrId;
  final int? count;
  final double? rating;

  AssignedProductDetails({
    required this.id,
    required this.category,
    required this.name,
    required this.image,
    required this.price,
    required this.size,
    this.status,
    this.qrId,
    this.count,
    this.rating,
  });

  factory AssignedProductDetails.fromJson(Map<String, dynamic> json) {
    return AssignedProductDetails(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '0',
      size: json['size'] ?? '',
      status: json['status'],
      qrId: json['qrId'],
      count: json['count'] is int
          ? json['count']
          : (json['count'] is String ? int.tryParse(json['count']) : null),
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
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
      if (status != null) 'status': status,
      if (qrId != null) 'qrId': qrId,
      if (count != null) 'count': count,
      if (rating != null) 'rating': rating,
    };
  }

  // Helper method to get complete image URL
  String getFullImageUrl() {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) {
      return image;
    }
    // Ensure we don't double up slashes
    final baseUrl = ApiEndpoints.imageBaseUrl;
    final imagePath = image.startsWith('/') ? image : '/$image';
    return '$baseUrl$imagePath';
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
      page: _parseToInt(json['page'], defaultValue: 1),
      limit: _parseToInt(json['limit'], defaultValue: 10),
      total: _parseToInt(json['total'], defaultValue: 0),
    );
  }

  // Helper method to safely parse dynamic value to int
  static int _parseToInt(dynamic value, {required int defaultValue}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    if (value is double) return value.round();
    return defaultValue;
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
