import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/auth/changed_pass_view.dart';
import 'package:qr_code_inventory/app/views/auth/otp_verify_screen.dart';
import 'package:qr_code_inventory/app/views/auth/reset_password_screen.dart';



class AuthController extends GetxController {
  // Observable variables for reactive state management
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var otpCode = "".obs;
  var termsAgreed = false.obs;

  // Text Editing Controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController createEmailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  // OTP Timer
  Timer? _timer;
  final RxInt _start = 120.obs; // 2 minutes in seconds
  RxString timerText = '02:00'.obs;

  @override
  void onClose() {
    _timer?.cancel();
    // Dispose all controllers
    loginEmailController.dispose();
    loginPasswordController.dispose();
    createEmailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    createPasswordController.dispose();
    confirmPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any existing timer
    _start.value = 120; // Reset timer
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          timer.cancel();
        } else {
          _start.value--;
          int minutes = _start.value ~/ 60;
          int seconds = _start.value % 60;
          timerText.value =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      },
    );
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Method to toggle remember me
  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }
  
  // Method to toggle terms agreement
  void toggleTermsAgreement(bool? value) {
    if (value != null) {
      termsAgreed.value = value;
    }
  }

  // --- Mock API Calls ---

  Future<void> login() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    print("Email: ${loginEmailController.text}");
    print("Password: ${loginPasswordController.text}");
    isLoading.value = false;
    // On success: Get.offAll(() => HomeScreen());
  }

  Future<void> createAccount() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    print("Email: ${createEmailController.text}");
    isLoading.value = false;
    Get.to(() => OTPScreen()); // Navigate to verification
  }

  Future<void> sendPasswordResetEmail() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    print("Forgot Password Email: ${forgotPasswordEmailController.text}");
    isLoading.value = false;
    Get.to(() => OTPScreen()); // Navigate to OTP screen
  }

  Future<void> verifyOTP(String otp) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    print("OTP: $otp");
    isLoading.value = false;
    Get.to(() => ResetPasswordScreen()); // Navigate to reset password
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    print("New Password: ${newPasswordController.text}");
    isLoading.value = false;
    Get.to(() => PasswordChangedScreen()); // Navigate to success screen
  }
}