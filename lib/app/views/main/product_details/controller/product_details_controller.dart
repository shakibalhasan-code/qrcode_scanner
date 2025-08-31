import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';

class ProductDetailsController extends GetxController {
  late Product product;
  final isFavorite = false.obs;
  final quantity = 1.obs;
  final selectedImageIndex = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Get the product from arguments
    product = Get.arguments as Product;
    // Check if product is in favorites (you can implement your logic here)
    isFavorite.value = false; // Default to false for now
  }
  
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    update();
  }
  
  void incrementQuantity() {
    quantity.value++;
  }
  
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
  
  void addToCart() {
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to cart',
      duration: const Duration(seconds: 2),
    );
  }
  
  void onBackPressed() {
    Get.back();
  }
  
  void shareProduct() {
    Get.snackbar(
      'Share',
      'Sharing ${product.name}',
      duration: const Duration(seconds: 1),
    );
  }
}
