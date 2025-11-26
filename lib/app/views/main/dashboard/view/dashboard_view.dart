import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/controller/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final controller = Get.put(DashboardController(), permanent: false);

  // Method to create bottom navigation bar item with HugeIcons
  BottomNavigationBarItem _buildNavItem({
    required IconData strokeIcon,
    required IconData? filledIcon,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8.w),
        // decoration: isSelected
        //     ? BoxDecoration(
        //         color: AppColors.accent.withOpacity(0.15),
        //         borderRadius: BorderRadius.circular(12.r),
        //       )
        //     : null,
        child: Icon(
          isSelected && filledIcon != null ? filledIcon : strokeIcon,
          size: 24.w,
          color: isSelected ? AppColors.accent : Colors.grey.shade600,
          fill: isSelected ? 1.0 : 0.0, // This simulates filled vs stroke
        ),
      ),
      label: '', // Empty string instead of null to satisfy Flutter's assertion
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.tabViews[controller.currentTabIndex.value]),
      bottomNavigationBar: Obx(() {
        final currentIndex = controller.currentTabIndex.value;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (i) {
            controller.changeTabIndex(i);
          },
          selectedItemColor: AppColors.accent,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
          items: [
            _buildNavItem(
              strokeIcon: HugeIcons.strokeRoundedHome01,
              filledIcon: HugeIcons
                  .strokeRoundedHome01, // Use same icon with fill property
              isSelected: currentIndex == 0,
            ),
            _buildNavItem(
              strokeIcon: HugeIcons.strokeRoundedFavourite,
              filledIcon: HugeIcons.strokeRoundedFavourite,
              isSelected: currentIndex == 1,
            ),
            _buildNavItem(
              strokeIcon: HugeIcons.strokeRoundedNotification01,
              filledIcon: HugeIcons.strokeRoundedNotification01,
              isSelected: currentIndex == 2,
            ),
            _buildNavItem(
              strokeIcon: HugeIcons.strokeRoundedUser,
              filledIcon: HugeIcons.strokeRoundedUser,
              isSelected: currentIndex == 3,
            ),
          ],
        );
      }),
    );
  }
}
