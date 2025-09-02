import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool hasSwitch;
  final bool isLogout;
  final bool isDelete;

  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.hasSwitch = false,
    this.isLogout = false,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasSwitch ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isLogout || isDelete
                  ? Colors.red.withOpacity(0.1) 
                  : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 22.w,
                color: isLogout || isDelete ? Colors.red : AppColors.primaryText,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isLogout || isDelete ? Colors.red : AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            
            // Trailing Widget (Arrow only)
            if (!isLogout && !isDelete)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: AppColors.secondaryText,
              ),
          ],
        ),
      ),
    );
  }
}
