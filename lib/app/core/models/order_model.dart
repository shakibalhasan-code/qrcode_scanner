class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity, 'price': price};
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class OrderRequest {
  final List<OrderItem> items;
  final double totalAmount;

  OrderRequest({required this.items, required this.totalAmount});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }
}

class Order {
  final String? id;
  final List<OrderItem> items;
  final double totalAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Order({
    this.id,
    required this.items,
    required this.totalAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      items:
          (json['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class OrderResponse {
  final bool success;
  final String message;
  final Order? order;

  OrderResponse({required this.success, required this.message, this.order});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      order: json['data'] != null ? Order.fromJson(json['data']) : null,
    );
  }
}
