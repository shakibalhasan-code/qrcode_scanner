class CartItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final String? size;
  final String? color;
  final double price;
  int quantity;
  final bool isSelected;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    this.size,
    this.color,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? image,
    String? size,
    String? color,
    double? price,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      size: size ?? this.size,
      color: color ?? this.color,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      size: json['size'],
      color: json['color'],
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'size': size,
      'color': color,
      'price': price,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }
}
