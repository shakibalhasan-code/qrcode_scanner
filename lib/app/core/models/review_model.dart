class Review {
  final String? id;
  final int rating;
  final String review;
  final String product;
  final String? user;
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
      product: json['product'] ?? '',
      user: json['user'],
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
      if (user != null) 'user': user,
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
