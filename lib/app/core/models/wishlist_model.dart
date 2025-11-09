import 'product_model.dart';

// Wishlist item model
class WishlistItem {
  final String id;
  final String userId;
  final Product product;
  final DateTime createdAt;
  final DateTime updatedAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    // Handle partial product data from wishlist API
    final productData = json['product'] ?? {};
    if (productData is Map<String, dynamic> && productData.isNotEmpty) {
      // Ensure we have the minimum required fields for Product
      if (!productData.containsKey('price')) productData['price'] = '0';
      if (!productData.containsKey('size')) productData['size'] = '';
      if (!productData.containsKey('status')) productData['status'] = 'active';
      if (!productData.containsKey('qrId')) productData['qrId'] = '';
      if (!productData.containsKey('image')) productData['image'] = '';
      if (!productData.containsKey('category')) {
        productData['category'] = {'_id': '', 'name': '', 'image': ''};
      }
      if (!productData.containsKey('createdAt')) {
        productData['createdAt'] = DateTime.now().toIso8601String();
      }
      if (!productData.containsKey('updatedAt')) {
        productData['updatedAt'] = DateTime.now().toIso8601String();
      }
    }

    return WishlistItem(
      id: json['_id'] ?? '',
      userId:
          json['user'] ??
          json['userId'] ??
          '', // Handle both 'user' and 'userId' fields
      product: Product.fromJson(productData),
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
      'userId': userId,
      'product': product.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WishlistItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Wishlist response models
class WishlistResponse {
  final bool success;
  final String message;
  final WishlistItem? data;

  WishlistResponse({required this.success, required this.message, this.data});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? WishlistItem.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

// Wishlist metadata
class WishlistMeta {
  final int page;
  final int total;

  WishlistMeta({required this.page, required this.total});

  factory WishlistMeta.fromJson(Map<String, dynamic> json) {
    return WishlistMeta(page: json['page'] ?? 1, total: json['total'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'total': total};
  }
}

// Wishlist data structure
class WishlistData {
  final List<WishlistItem> result;
  final WishlistMeta meta;

  WishlistData({required this.result, required this.meta});

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      result:
          (json['result'] as List<dynamic>?)
              ?.map((item) => WishlistItem.fromJson(item))
              .toList() ??
          [],
      meta: WishlistMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class WishlistListResponse {
  final bool success;
  final String message;
  final WishlistData data;

  WishlistListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WishlistListResponse.fromJson(Map<String, dynamic> json) {
    return WishlistListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: WishlistData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

// Simple response for add/remove operations
class WishlistActionResponse {
  final bool success;
  final String message;

  WishlistActionResponse({required this.success, required this.message});

  factory WishlistActionResponse.fromJson(Map<String, dynamic> json) {
    return WishlistActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
