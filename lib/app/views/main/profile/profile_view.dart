import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/profile/controller/profile_controller.dart';
import 'package:qr_code_inventory/app/views/main/profile/widgets/profile_header_widget.dart';
import 'package:qr_code_inventory/app/views/main/profile/widgets/profile_stats_widget.dart';
import 'package:qr_code_inventory/app/views/main/profile/widgets/profile_menu_item_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController(), permanent: false);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(
          () => controller.isLoadingProfile.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: controller.refreshUserProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),

                        // Profile Header
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: ProfileHeaderWidget(
                            userName: controller.userName.value,
                            userEmail: controller.userEmail.value,
                            userPhone: controller.userPhone.value,
                            avatarUrl: controller.userAvatar.value,
                            selectedImage:
                                controller.selectedProfileImage.value,
                            onEditProfile: controller.onEditProfile,
                          ),
                        ),

                        SizedBox(height: 0.h),

                        // Profile Stats
                        // const ProfileStatsWidget(),
                        SizedBox(height: 8.h),

                        // Profile Menu
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 8.h),

                              // Menu Items
                              ...controller.profileMenuItems.map(
                                (item) => ProfileMenuItemWidget(
                                  icon: item.icon,
                                  title: item.title,
                                  subtitle: item.subtitle,
                                  onTap: item.onTap,
                                  hasSwitch: item.hasSwitch,
                                  isLogout: item.isLogout,
                                  isDelete: item.isDelete,
                                ),
                              ),

                              SizedBox(height: 20.h),

                              // App Version
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  'Version 1.0.0',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 80.h,
                              ), // Bottom padding for navigation
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
