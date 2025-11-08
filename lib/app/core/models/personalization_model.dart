class PersonalizationRequest {
  final String category;
  final String email;
  final String name;
  final DateTime birthday;

  PersonalizationRequest({
    required this.category,
    required this.email,
    required this.name,
    required this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'email': email,
      'name': name,
      'birthday': birthday.toIso8601String(),
    };
  }
}

class PersonalizationResponse {
  final bool success;
  final String message;
  final dynamic data;

  PersonalizationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PersonalizationResponse.fromJson(Map<String, dynamic> json) {
    return PersonalizationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}
