import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/cart/cart_view.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String greeting;
  final String userName;
  
  const HomeHeaderWidget({
    super.key,
    required this.greeting,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30.w,
            ),
          ),
          SizedBox(width: 12.w),
          
          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          
          // Shopping Cart Icon
          GestureDetector(
            onTap: () => Get.to(() => const CartView()),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 24.w,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
