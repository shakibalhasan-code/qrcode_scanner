import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/cart_item_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[
    // Sample cart items matching the design
    CartItem(
      id: '1',
      productId: 'product_1',
      name: 'Apple Magic Mouse 2 – Wirel...',
      image: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      size: '-',
      color: 'White',
      price: 79.00,
      quantity: 1,
      isSelected: true,
    ),
    CartItem(
      id: '2',
      productId: 'product_2',
      name: 'Smart Tag Keychains 2 – Pack of 2',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      size: 'L',
      color: 'Dusty Blue',
      price: 19.90,
      quantity: 1,
      isSelected: false,
    ),
    CartItem(
      id: '3',
      productId: 'product_3',
      name: 'Logitech MX Master 3S – Perf...',
      image: 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500',
      size: '-',
      color: 'Graphite',
      price: 89.99,
      quantity: 2,
      isSelected: true,
    ),
    CartItem(
      id: '4',
      productId: 'product_4',
      name: 'COS Relaxed Fit Cotton...',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      size: 'M',
      color: 'Soft Beige',
      price: 65.00,
      quantity: 1,
      isSelected: true,
    ),
  ].obs;

  final RxBool isSelectAll = false.obs;
  final RxBool showDeleteDialog = false.obs;
  final Rx<CartItem?> itemToDelete = Rx<CartItem?>(null);

  // Getters
  List<CartItem> get selectedItems => cartItems.where((item) => item.isSelected).toList();
  
  int get selectedItemsCount => selectedItems.length;
  
  int get totalItemsCount => cartItems.length;
  
  double get totalAmount => selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get hasSelectedItems => selectedItems.isNotEmpty;

  void onBackPressed() {
    Get.back();
  }

  void toggleSelectAll() {
    isSelectAll.value = !isSelectAll.value;
    for (int i = 0; i < cartItems.length; i++) {
      cartItems[i] = cartItems[i].copyWith(isSelected: isSelectAll.value);
    }
    cartItems.refresh();
    _updateSelectAllState();
  }

  void toggleItemSelection(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(
        isSelected: !cartItems[index].isSelected,
      );
      cartItems.refresh();
      _updateSelectAllState();
    }
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
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
      cartItems.refresh();
    }
  }

  void decreaseQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity - 1,
      );
      cartItems.refresh();
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
      cartItems.removeWhere((item) => item.id == itemToDelete.value!.id);
      hideDeleteDialog();
      _updateSelectAllState();
      
      Get.snackbar(
        'Removed',
        'Item removed from cart',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
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
    _updateSelectAllState();
  }
}
