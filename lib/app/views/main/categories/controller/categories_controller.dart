import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/core/models/category_model.dart';
import 'package:qr_code_inventory/app/views/main/product_details/product_details_view.dart';

class CategoriesController extends GetxController {
  final allProducts = <Product>[
    Product(
      id: '1',
      name: 'New Balance Hat Core',
      image:
          'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=500',
      price: '25.00',
      size: 'Medium',
      status: 'active',
      qrId: 'QR001',
      category: Category(id: 'accessories', name: 'Accessories', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'The Ordinary Nike Jordan 100%',
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      price: '150.00',
      size: 'Large',
      status: 'active',
      qrId: 'QR002',
      category: Category(id: 'shoes', name: 'Shoes', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'Smart Tag Keychains 2 – Pack of 2',
      image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      price: '35.00',
      size: 'Small',
      status: 'active',
      qrId: 'QR003',
      category: Category(id: 'accessories', name: 'Accessories', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '4',
      name: 'Clarks Leather Crossbody Bag',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      price: '89.00',
      size: 'Medium',
      status: 'active',
      qrId: 'QR004',
      category: Category(id: 'bags', name: 'Bags', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '5',
      name: 'New Balance 574 Core Sneakers',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
      price: '80.00',
      size: 'Large',
      status: 'active',
      qrId: 'QR005',
      category: Category(id: 'shoes', name: 'Shoes', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '6',
      name: 'The Ordinary Niacinamide 10%',
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
      price: '12.00',
      size: 'Small',
      status: 'active',
      qrId: 'QR006',
      category: Category(id: 'beauty', name: 'Beauty', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '7',
      name: 'Samsung SmartTag 2 – Pack of 2',
      image:
          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      price: '45.00',
      size: 'Small',
      status: 'active',
      qrId: 'QR007',
      category: Category(id: 'electronics', name: 'Electronics', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '8',
      name: 'Clarks Leather Crossbody Bag',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      price: '89.00',
      size: 'Medium',
      status: 'active',
      qrId: 'QR008',
      category: Category(id: 'bags', name: 'Bags', image: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ].obs;

  void onProductTap(Product product) {
    Get.to(
      () => const ProductDetailsView(),
      arguments: product,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void onBackPressed() {
    Get.back();
  }
}
