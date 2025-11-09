import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';
import 'package:qr_code_inventory/app/views/main/profile/controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final nameController = TextEditingController(text: controller.userName.value);
    final emailController = TextEditingController(text: controller.userEmail.value);
    final phoneController = TextEditingController(text: controller.userPhone.value);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.w,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            
            // Profile Avatar Section
            Center(
              child: Obx(() => Stack(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 3.w,
                      ),
                    ),
                    child: ClipOval(
                      child: controller.selectedProfileImage.value != null
                          ? Image.file(
                              controller.selectedProfileImage.value!,
                              fit: BoxFit.cover,
                              width: 120.w,
                              height: 120.w,
                            )
                          : Icon(
                              Icons.person,
                              size: 60.w,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.onChangeProfileImage,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.w,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 18.w,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            
            SizedBox(height: 40.h),
            
            // Form Fields
            CustomTextField(
              label: 'Full Name',
              controller: nameController,
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline,
            ),
            
            SizedBox(height: 24.h),
            
            CustomTextField(
              label: 'Email',
              controller: emailController,
              hint: 'Email address (read-only)',
              prefixIcon: Icons.email_outlined,
              readOnly: true,
            ),
            
            SizedBox(height: 24.h),
            
            CustomTextField(
              label: 'Phone Number',
              controller: phoneController,
              hint: 'Enter your phone number',
              prefixIcon: Icons.phone_outlined,
            ),
            
            SizedBox(height: 40.h),
            
            // Save Button
            Obx(() => PrimaryButton(
              text: controller.isUpdatingProfile.value ? 'Saving...' : 'Save Changes',
              onPressed: () async {
                if (!controller.isUpdatingProfile.value) {
                  await controller.saveProfileChanges(
                    name: nameController.text.trim(),
                    // email: emailController.text.trim(), // Remove email since it's read-only
                    phone: phoneController.text.trim(),
                  );
                  // Don't navigate back immediately, let the method handle success/error
                  if (!controller.isUpdatingProfile.value) {
                    Get.back();
                  }
                }
              },
            )),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
