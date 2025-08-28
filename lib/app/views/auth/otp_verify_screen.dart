import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/controllers/auth_controller.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the auth controller instance
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
                'Verify Your Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We've sent a 6-digit code to your email. Enter it below to confirm your account and start shopping.",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'OTP Code',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText),
              ),
              const SizedBox(height: 16),
              OtpTextField(
                numberOfFields: 6,
                // Styling for each box
              
                fieldWidth: 50,
                // Space between boxes
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Default text and style
                obscureText: true,
               
                // Border properties
                borderColor: AppColors.textFieldBorder,
                enabledBorderColor: AppColors.textFieldBorder,
                focusedBorderColor: AppColors.textFieldBorder,
                // Callback when code is entered
                onSubmit: (String verificationCode) {
                  // Update the reactive variable
                  authController.otpCode.value = verificationCode;
                  // You can add navigation logic here
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Resend code in : ',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
                  ),
                  Obx(() => Text(
                    '${authController.timerText.value.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )),
                ],
              ),
              const SizedBox(height: 32),
              Obx(() => PrimaryButton(
                text: authController.isLoading.value ? 'Loading...' : 'Verify My Account',
                onPressed: authController.isLoading.value
                    ? (){}
                    : () {
                        authController.verifyOTP(authController.otpCode.value);
                      },
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive code yet? ",
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  TextButton(
                    onPressed: () {
                      authController.startTimer();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
