import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';
import 'package:qr_code_inventory/app/widgets/password_requirements.dart';
import 'package:qr_code_inventory/app/widgets/phone_number_feild.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart' show PrimaryButton;

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: 'Email',
                  controller: authController.createEmailController,
                  hint: 'Input your email here',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Full Name',
                  controller: authController.fullNameController,
                  hint: 'Input your name here',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                PhoneNumberField(
                  label: 'Phone Number',
                  controller: authController.phoneController,
                  hint: 'XXXX XXXX XXXX',
                ),
                const SizedBox(height: 24),
                Obx(() => CustomTextField(
                  label: 'Password',
                  controller: authController.createPasswordController,
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
                const SizedBox(height: 16),
                const PasswordRequirement(
                    text: 'Password Must Be At Least 8 Characters Long'),
                const PasswordRequirement(
                    text: 'At Least One Uppercase Letter and One Number'),
                const PasswordRequirement(
                    text: 'At Least One Special Character'),
                const SizedBox(height: 24),
                Obx(() => CustomTextField(
                  label: 'Confirm Password',
                  controller: authController.confirmPasswordController,
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
                Row(
                  children: [
                    Obx(() => Checkbox(
                          value: authController.termsAgreed.value,
                          onChanged: (value) => authController.toggleTermsAgreement(value),
                          visualDensity: VisualDensity.compact,
                        )),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.secondaryText),
                          children: [
                            const TextSpan(text: 'I agree with all '),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Terms & Conditions tap
                                },
                            ),
                            const TextSpan(text: ' & '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Privacy Policy tap
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Obx(() => PrimaryButton(
                  text: authController.isLoading.value ? 'Loading...' : 'Sign Up',
                  onPressed: authController.isLoading.value
                      ? (){} // Provide an empty function when disabled
                      : () {
                          authController.createAccount();
                        },
                )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You already have account? ",
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.LOGIN),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

