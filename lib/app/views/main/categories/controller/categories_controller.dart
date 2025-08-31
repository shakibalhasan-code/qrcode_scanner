import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';

class CategoriesController extends GetxController {
  final allProducts = <Product>[
    Product(
      id: '1',
      name: 'New Balance Hat Core',
      image: 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=500',
      price: 25.00,
      categoryId: 'accessories',
    ),
    Product(
      id: '2',
      name: 'The Ordinary Nike Jordan 100%',
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      price: 150.00,
      categoryId: 'shoes',
    ),
    Product(
      id: '3',
      name: 'Smart Tag Keychains 2 – Pack of 2',
      image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      price: 35.00,
      categoryId: 'accessories',
    ),
    Product(
      id: '4',
      name: 'Clarks Leather Crossbody Bag',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      price: 89.00,
      categoryId: 'bags',
    ),
    Product(
      id: '5',
      name: 'New Balance 574 Core Sneakers',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
      price: 80.00,
      categoryId: 'shoes',
    ),
    Product(
      id: '6',
      name: 'The Ordinary Niacinamide 10%',
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
      price: 12.00,
      categoryId: 'beauty',
    ),
    Product(
      id: '7',
      name: 'Samsung SmartTag 2 – Pack of 2',
      image: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      price: 45.00,
      categoryId: 'electronics',
    ),
    Product(
      id: '8',
      name: 'Clarks Leather Crossbody Bag',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      price: 89.00,
      categoryId: 'bags',
    ),
  ].obs;

  void onProductTap(Product product) {
    Get.snackbar(
      'Product Selected',
      product.name,
      duration: const Duration(seconds: 1),
    );
  }

  void onBackPressed() {
    Get.back();
  }
}
