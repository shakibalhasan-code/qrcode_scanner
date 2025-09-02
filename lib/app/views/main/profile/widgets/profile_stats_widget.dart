import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int ordersCount;
  final int wishlistCount;
  final int reviewsCount;

  const ProfileStatsWidget({
    super.key,
    this.ordersCount = 12,
    this.wishlistCount = 25,
    this.reviewsCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Orders',
            count: ordersCount,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            count: wishlistCount,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.star_outline,
            title: 'Reviews',
            count: reviewsCount,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required int count,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}
