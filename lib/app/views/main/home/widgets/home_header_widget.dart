import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/cart/cart_view.dart';
import 'package:qr_code_inventory/app/core/models/user_model.dart';
import 'package:qr_code_inventory/app/core/services/cart_service.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String greeting;
  final String userName;
  final User? userProfile;
  final bool isLoading;

  const HomeHeaderWidget({
    super.key,
    required this.greeting,
    required this.userName,
    this.userProfile,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Profile Image
          _buildProfileAvatar(),
          SizedBox(width: 12.w),

          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (userProfile?.isVerified == true) ...[
                      SizedBox(width: 4.w),
                      Icon(Icons.verified, size: 14.w, color: Colors.blue),
                    ],
                  ],
                ),
                isLoading
                    ? Container(
                        height: 18.h,
                        width: 120.w,
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      )
                    : Text(
                        userProfile?.displayName ?? userName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
              ],
            ),
          ),

          // Shopping Cart Icon with Badge
          _buildCartIcon(),
          SizedBox(width: 10.w),
          IconButton(onPressed: () {}, icon: Icon(Icons.qr_code_scanner)),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    if (isLoading) {
      return CircleAvatar(
        radius: 24.r,
        backgroundColor: Colors.grey[300],
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
      );
    }

    // Check if user has profile image
    final imageUrl = userProfile?.getFullImageUrl();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24.r,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey[300],
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Error loading profile image: $exception');
        },
        child: null,
      );
    }

    // Use initials or default icon
    return CircleAvatar(
      radius: 24.r,
      backgroundColor: AppColors.accent.withOpacity(0.2),
      child: userProfile != null
          ? Text(
              userProfile!.initials,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            )
          : Icon(Icons.person, color: AppColors.accent, size: 24.w),
    );
  }

  Widget _buildCartIcon() {
    final CartService cartService = Get.find<CartService>();
    
    return GestureDetector(
      onTap: () => Get.to(() => const CartView()),
      child: Stack(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 24.w,
            color: AppColors.primaryText,
          ),
          Obx(() {
            final itemCount = cartService.totalItems;
            if (itemCount == 0) return const SizedBox.shrink();
            
            return Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
