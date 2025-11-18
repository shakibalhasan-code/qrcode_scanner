// Import category model for nested category
import 'category_model.dart';
import '../api_endpoints.dart';

// Review detail user model
class ReviewUser {
  final String id;
  final String name;
  final String email;

  ReviewUser({required this.id, required this.name, required this.email});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Anonymous',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

// Review detail model
class ReviewDetail {
  final String id;
  final int rating;
  final String review;
  final ReviewUser user;
  final DateTime createdAt;

  ReviewDetail({
    required this.id,
    required this.rating,
    required this.review,
    required this.user,
    required this.createdAt,
  });

  factory ReviewDetail.fromJson(Map<String, dynamic> json) {
    return ReviewDetail(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      user: ReviewUser.fromJson(json['user'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rating': rating,
      'review': review,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Get formatted time ago string
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Rating statistics model
class RatingStats {
  final int totalReviews;
  final Map<String, int> counts;
  final Map<String, double> percentages;
  final List<ReviewDetail> getReviewDetails;

  RatingStats({
    required this.totalReviews,
    required this.counts,
    required this.percentages,
    required this.getReviewDetails,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to double
    Map<String, double> convertToDoubleMap(Map<String, dynamic>? source) {
      if (source == null) return {};
      return source.map((key, value) {
        if (value is int) {
          return MapEntry(key, value.toDouble());
        } else if (value is double) {
          return MapEntry(key, value);
        } else {
          return MapEntry(key, 0.0);
        }
      });
    }

    // Parse review details
    List<ReviewDetail> parseReviewDetails(List<dynamic>? reviewsList) {
      if (reviewsList == null || reviewsList.isEmpty) return [];

      return reviewsList
          .map(
            (review) => ReviewDetail.fromJson(review as Map<String, dynamic>),
          )
          .toList();
    }

    return RatingStats(
      totalReviews: json['totalReviews'] ?? 0,
      counts: Map<String, int>.from(json['counts'] ?? {}),
      percentages: convertToDoubleMap(json['percentages']),
      getReviewDetails: parseReviewDetails(json['getReviewDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'counts': counts,
      'percentages': percentages,
      'getReviewDetails': getReviewDetails
          .map((review) => review.toJson())
          .toList(),
    };
  }

  // Calculate average rating from percentages
  double get averageRating {
    if (totalReviews == 0) return 0.0;

    double sum = 0.0;
    for (int i = 1; i <= 5; i++) {
      sum += i * (counts['$i'] ?? 0);
    }
    return totalReviews > 0 ? sum / totalReviews : 0.0;
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final String price; // API returns string, not double
  final String size;
  final String status;
  final String qrId;
  final Category category; // Nested category object
  final DateTime createdAt;
  final DateTime updatedAt;
  final RatingStats? ratingStats; // Rating statistics from API

  // -- Fields added for UI --
  final double rating;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.size,
    required this.status,
    required this.qrId,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.ratingStats,
    this.rating = 0.0,
    this.isFavorite = false,
  });

  // Factory constructor for creating Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '0',
      size: json['size'] ?? '',
      status: json['status'] ?? 'active',
      qrId: json['qrId'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      ratingStats: json['ratingStats'] != null
          ? RatingStats.fromJson(json['ratingStats'])
          : null,
      rating: json['rating']?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Method for converting Product to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'price': price,
      'size': size,
      'status': status,
      'qrId': qrId,
      'category': category.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ratingStats': ratingStats?.toJson(),
      'rating': rating,
      'isFavorite': isFavorite,
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

  // Helper method to get rating from rating stats or fallback to rating field
  double get effectiveRating {
    return ratingStats?.averageRating ?? rating;
  }

  // Helper method to get total reviews count
  int get totalReviews {
    return ratingStats?.totalReviews ?? 0;
  }

  // CopyWith method for creating modified copies
  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? price,
    String? size,
    String? status,
    String? qrId,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    RatingStats? ratingStats,
    double? rating,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      size: size ?? this.size,
      status: status ?? this.status,
      qrId: qrId ?? this.qrId,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ratingStats: ratingStats ?? this.ratingStats,
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

class ProductMeta {
  final int page;
  final int total;

  ProductMeta({required this.page, required this.total});

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(page: json['page'] ?? 1, total: json['total'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'total': total};
  }
}

class ProductData {
  final List<Product> result;
  final ProductMeta meta;

  ProductData({required this.result, required this.meta});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      result:
          (json['result'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      meta: ProductMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.map((product) => product.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class ProductResponse {
  final bool success;
  final String message;
  final ProductData data;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

// Response model for single product details
class ProductDetailsResponse {
  final bool success;
  final String message;
  final Product data;

  ProductDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Product.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
