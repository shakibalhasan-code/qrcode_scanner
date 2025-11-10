import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/cart_item_model.dart';
import 'package:qr_code_inventory/app/core/services/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxBool isSelectAll = false.obs;
  final RxBool showDeleteDialog = false.obs;
  final Rx<CartItem?> itemToDelete = Rx<CartItem?>(null);

  // Getters that delegate to CartService
  List<CartItem> get cartItems => _cartService.cartItems;
  List<CartItem> get selectedItems => _cartService.selectedItems;
  int get selectedItemsCount => _cartService.selectedItemsCount;
  int get totalItemsCount => _cartService.totalItems;
  double get totalAmount => _cartService.totalAmount;
  bool get hasSelectedItems => selectedItems.isNotEmpty;

  void onBackPressed() {
    Get.back();
  }

  void toggleSelectAll() {
    if (isSelectAll.value) {
      _cartService.deselectAllItems();
    } else {
      _cartService.selectAllItems();
    }
    _updateSelectAllState();
  }

  void toggleItemSelection(String itemId) {
    _cartService.toggleItemSelection(itemId);
    _updateSelectAllState();
  }

  void _updateSelectAllState() {
    if (cartItems.isEmpty) {
      isSelectAll.value = false;
      return;
    }
    
    final allSelected = cartItems.every((item) => item.isSelected);
    final noneSelected = cartItems.every((item) => !item.isSelected);
    
    if (allSelected) {
      isSelectAll.value = true;
    } else if (noneSelected) {
      isSelectAll.value = false;
    } else {
      isSelectAll.value = false;
    }
  }

  void increaseQuantity(String itemId) {
    final item = cartItems.firstWhere((item) => item.id == itemId);
    _cartService.updateQuantity(itemId, item.quantity + 1);
  }

  void decreaseQuantity(String itemId) {
    final item = cartItems.firstWhere((item) => item.id == itemId);
    if (item.quantity > 1) {
      _cartService.updateQuantity(itemId, item.quantity - 1);
    }
  }

  void showDeleteItemDialog(CartItem item) {
    itemToDelete.value = item;
    showDeleteDialog.value = true;
  }

  void hideDeleteDialog() {
    showDeleteDialog.value = false;
    itemToDelete.value = null;
  }

  void deleteItem() {
    if (itemToDelete.value != null) {
      _cartService.removeFromCart(itemToDelete.value!.id);
      hideDeleteDialog();
      _updateSelectAllState();
    }
  }

  void editItem(CartItem item) {
    // Navigate to edit item screen or show edit dialog
    Get.snackbar(
      'Edit',
      'Edit functionality for ${item.name}',
      duration: const Duration(seconds: 2),
    );
  }

  void checkout() {
    if (!hasSelectedItems) {
      Get.snackbar(
        'No Items Selected',
        'Please select items to checkout',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return;
    }

    Get.snackbar(
      'Checkout',
      'Proceeding to checkout with ${selectedItemsCount} items',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to cart changes and update select all state
    ever(_cartService.cartItems, (_) => _updateSelectAllState());
    _updateSelectAllState();
  }

  // Add additional utility methods
  void clearCart() {
    _cartService.clearCart();
    _updateSelectAllState();
  }

  // Calculate delivery fee (this could be dynamic based on location, etc.)
  double get deliveryFee => totalAmount > 100 ? 0.0 : 5.99;

  // Calculate total with delivery
  double get totalWithDelivery => totalAmount + deliveryFee;

  // Check if delivery is free
  bool get isFreeDelivery => deliveryFee == 0.0;
}
