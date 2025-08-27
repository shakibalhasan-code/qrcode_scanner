import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the auth controller
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F5F5),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Let's get you back on track. Set a new password to secure your account.",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 48),
              Obx(() => CustomTextField(
                label: 'New Password',
                controller: authController.newPasswordController,
                hint: '*********',
                prefixIcon: Icons.lock_outline,
                obscureText: !authController.isPasswordVisible.value,
                suffixIcon: authController.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixIconPressed: () {
                  authController.togglePasswordVisibility();
                },
              )),
              const SizedBox(height: 24),
              Obx(() => CustomTextField(
                label: 'Confirm New Password',
                controller: authController.confirmNewPasswordController,
                hint: '*********',
                prefixIcon: Icons.lock_outline,
                obscureText: !authController.isPasswordVisible.value,
                suffixIcon: authController.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixIconPressed: () {
                  authController.togglePasswordVisibility();
                },
              )),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Reset Password',
                onPressed: () {
                  authController.resetPassword();
                  // After successful password reset, navigate to the password changed screen
                  Get.toNamed(Routes.PASSWORD_CHANGED);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}