import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends GetxService {
  final GetStorage _storage = GetStorage();
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  static const String _cartKey = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  // Load cart items from storage
  void _loadCartFromStorage() {
    debugPrint('🛒 Loading cart items from storage');

    try {
      final List<dynamic>? storedItems = _storage.read(_cartKey);
      if (storedItems != null) {
        cartItems.clear();
        for (var item in storedItems) {
          cartItems.add(CartItem.fromJson(Map<String, dynamic>.from(item)));
        }
        debugPrint('✅ Loaded ${cartItems.length} cart items from storage');
      } else {
        debugPrint('ℹ️ No cart items found in storage');
      }
    } catch (e) {
      debugPrint('💥 Error loading cart items from storage: $e');
    }
  }

  // Save cart items to storage
  void _saveCartToStorage() {
    debugPrint('💾 Saving ${cartItems.length} cart items to storage');

    try {
      final List<Map<String, dynamic>> itemsJson = cartItems
          .map((item) => item.toJson())
          .toList();
      _storage.write(_cartKey, itemsJson);
      debugPrint('✅ Cart items saved successfully');
    } catch (e) {
      debugPrint('💥 Error saving cart items to storage: $e');
    }
  }

  // Add product to cart
  bool addToCart(
    Product product, {
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) {
    debugPrint('🛒 Adding product to cart: ${product.name} (qty: $quantity)');

    try {
      // Check if product already exists in cart
      final existingItemIndex = cartItems.indexWhere(
        (item) =>
            item.productId == product.id &&
            item.size == selectedSize &&
            item.color == selectedColor,
      );

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = cartItems[existingItemIndex];
        cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        debugPrint('✅ Updated quantity for existing cart item');
      } else {
        // Add new item to cart
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          name: product.name,
          image: product.getFullImageUrl(),
          size: selectedSize,
          color: selectedColor,
          price: double.tryParse(product.price) ?? 0.0,
          quantity: quantity,
          isSelected: true,
        );

        cartItems.add(cartItem);
        debugPrint('✅ Added new item to cart');
      }

      _saveCartToStorage();

      // Don't show snackbar from service - let the calling controller handle UI feedback
      return true;
    } catch (e) {
      debugPrint('💥 Error adding product to cart: $e');
      return false;
    }
  }

  // Remove item from cart
  CartItem? removeFromCart(String cartItemId) {
    debugPrint('🗑️ Removing item from cart: $cartItemId');

    try {
      final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);

      if (itemIndex != -1) {
        final removedItem = cartItems[itemIndex];
        cartItems.removeAt(itemIndex);
        _saveCartToStorage();

        debugPrint('✅ Item removed from cart successfully');
        return removedItem; // Return the removed item for UI feedback
      } else {
        debugPrint('⚠️ Item not found in cart');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error removing item from cart: $e');
      return null;
    }
  }

  // Update item quantity
  bool updateQuantity(String cartItemId, int newQuantity) {
    debugPrint(
      '📊 Updating quantity for cart item: $cartItemId to $newQuantity',
    );

    try {
      if (newQuantity <= 0) {
        final removedItem = removeFromCart(cartItemId);
        return removedItem != null;
      }

      final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);

      if (itemIndex != -1) {
        cartItems[itemIndex] = cartItems[itemIndex].copyWith(
          quantity: newQuantity,
        );
        _saveCartToStorage();
        debugPrint('✅ Quantity updated successfully');
        return true;
      } else {
        debugPrint('⚠️ Item not found in cart');
        return false;
      }
    } catch (e) {
      debugPrint('💥 Error updating quantity: $e');
      return false;
    }
  }

  // Toggle item selection
  void toggleItemSelection(String cartItemId) {
    debugPrint('🔄 Toggling selection for cart item: $cartItemId');

    try {
      final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);

      if (itemIndex != -1) {
        final currentItem = cartItems[itemIndex];
        cartItems[itemIndex] = currentItem.copyWith(
          isSelected: !currentItem.isSelected,
        );
        _saveCartToStorage();
        debugPrint('✅ Item selection toggled');
      }
    } catch (e) {
      debugPrint('💥 Error toggling item selection: $e');
    }
  }

  // Select all items
  void selectAllItems() {
    debugPrint('✅ Selecting all cart items');

    try {
      for (int i = 0; i < cartItems.length; i++) {
        cartItems[i] = cartItems[i].copyWith(isSelected: true);
      }
      _saveCartToStorage();
    } catch (e) {
      debugPrint('💥 Error selecting all items: $e');
    }
  }

  // Deselect all items
  void deselectAllItems() {
    debugPrint('❌ Deselecting all cart items');

    try {
      for (int i = 0; i < cartItems.length; i++) {
        cartItems[i] = cartItems[i].copyWith(isSelected: false);
      }
      _saveCartToStorage();
    } catch (e) {
      debugPrint('💥 Error deselecting all items: $e');
    }
  }

  // Clear entire cart
  void clearCart() {
    debugPrint('🧹 Clearing entire cart');

    try {
      cartItems.clear();
      _saveCartToStorage();
    } catch (e) {
      debugPrint('💥 Error clearing cart: $e');
    }
  }

  // Check if product is in cart
  bool isProductInCart(String productId) {
    return cartItems.any((item) => item.productId == productId);
  }

  // Get total cart amount (selected items only)
  double get totalAmount {
    return cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Get total items count
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get selected items count
  int get selectedItemsCount {
    return cartItems.where((item) => item.isSelected).length;
  }

  // Get selected items total quantity
  int get selectedItemsQuantity {
    return cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Get cart items (read-only)
  List<CartItem> get items => List.unmodifiable(cartItems);

  // Get selected cart items
  List<CartItem> get selectedItems =>
      cartItems.where((item) => item.isSelected).toList();
}
