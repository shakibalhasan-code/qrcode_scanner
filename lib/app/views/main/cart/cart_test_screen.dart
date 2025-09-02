import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/cart/cart_view.dart';

class CartTestScreen extends StatelessWidget {
  const CartTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.to(() => const CartView()),
          child: const Text('Open Cart'),
        ),
      ),
    );
  }
}
