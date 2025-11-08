import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to track your orders and place new orders.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 48),

                CustomTextField(
                  label: 'Email',
                  controller: authController.loginEmailController,
                  hint: 'Input your email here',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                Obx(
                  () => CustomTextField(
                    label: 'Password',
                    controller: authController.loginPasswordController,
                    hint: '*********',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !authController.isPasswordVisible.value,
                    suffixIcon: authController.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixIconPressed: () {
                      authController.togglePasswordVisibility();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: authController.rememberMe.value,
                            onChanged: (value) =>
                                authController.toggleRememberMe(value),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Obx(
                  () => PrimaryButton(
                    text: authController.isLoading.value
                        ? 'Loading...'
                        : 'Login',
                    onPressed: authController.isLoading.value
                        ? () {} // Provide an empty function when disabled
                        : () {
                            authController.login();
                          },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account yet? ",
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.CREATE_ACCOUNT),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
