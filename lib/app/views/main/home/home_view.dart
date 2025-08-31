import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/home/controller/home_controller.dart';
import 'package:qr_code_inventory/app/views/main/home/widgets/home_header_widget.dart';
import 'package:qr_code_inventory/app/views/main/home/widgets/home_search_widget.dart';
import 'package:qr_code_inventory/app/views/main/home/widgets/home_categories_widget.dart';
import 'package:qr_code_inventory/app/views/main/home/widgets/home_special_products_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8.h),
              
              // Header Section
              GetBuilder<HomeController>(
                builder: (controller) => HomeHeaderWidget(
                  greeting: controller.greeting.value,
                  userName: controller.userName.value,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Search Section
              const HomeSearchWidget(),
              
              SizedBox(height: 24.h),
              
              // Categories Section
              GetBuilder<HomeController>(
                builder: (controller) => HomeCategoriesWidget(
                  categories: controller.categories,
                  onSeeAll: controller.onSeeAllCategories,
                  onCategoryTap: controller.onCategoryTap,
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Special Products Section
              GetBuilder<HomeController>(
                builder: (controller) => HomeSpecialProductsWidget(
                  products: controller.specialProducts,
                  onSeeAll: controller.onSeeAllSpecialProducts,
                  onProductTap: controller.onProductTap,
                  onToggleFavorite: controller.toggleFavorite,
                  isFavorite: controller.isFavorite,
                ),
              ),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
