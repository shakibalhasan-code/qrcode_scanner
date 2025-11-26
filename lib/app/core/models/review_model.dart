// User model for review
class ReviewUser {
  final String id;
  final String name;
  final String email;
  final String? image;

  ReviewUser({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown User',
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
}

class Review {
  final String? id;
  final int rating;
  final String review;
  final String product;
  final ReviewUser? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    this.id,
    required this.rating,
    required this.review,
    required this.product,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating Review from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      product: json['product'] is String
          ? json['product']
          : json['product']?['_id'] ?? '',
      user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Method for converting Review to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'rating': rating,
      'review': review,
      'product': product,
      if (user != null) 'user': user!.toJson(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Method for creating request body
  Map<String, dynamic> toRequestBody() {
    return {'rating': rating, 'review': review, 'product': product};
  }

  @override
  String toString() {
    return 'Review{id: $id, rating: $rating, review: $review, product: $product}';
  }
}

// Meta model for pagination
class ReviewMeta {
  final int page;
  final int limit;
  final int total;

  ReviewMeta({required this.page, required this.limit, required this.total});

  factory ReviewMeta.fromJson(Map<String, dynamic> json) {
    return ReviewMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'total': total};
  }
}

// Response model for fetching reviews
class GetReviewsResponse {
  final bool success;
  final String message;
  final List<Review> reviews;
  final ReviewMeta meta;

  GetReviewsResponse({
    required this.success,
    required this.message,
    required this.reviews,
    required this.meta,
  });

  factory GetReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final result = data['result'] as List<dynamic>? ?? [];
    final metaData = data['meta'] ?? {};

    return GetReviewsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      reviews: result.map((review) => Review.fromJson(review)).toList(),
      meta: ReviewMeta.fromJson(metaData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'result': reviews.map((review) => review.toJson()).toList(),
        'meta': meta.toJson(),
      },
    };
  }
}

// Response model for review submission
class ReviewResponse {
  final bool success;
  final String message;
  final Review? data;

  ReviewResponse({required this.success, required this.message, this.data});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Review.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}
