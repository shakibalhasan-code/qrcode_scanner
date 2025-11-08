import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/auth/changed_pass_view.dart';
import 'package:qr_code_inventory/app/views/auth/otp_verify_screen.dart';
import 'package:qr_code_inventory/app/views/auth/reset_password_screen.dart';
import 'package:qr_code_inventory/app/views/auth/signin_screen.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/view/dashboard_view.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/personalization_screen.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/bindings/personalization_binding.dart';
import 'package:qr_code_inventory/app/core/services/auth_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';

class AuthController extends GetxController {
  // Services
  late AuthService authService;
  late TokenStorage tokenStorage;

  // Observable variables for reactive state management
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var otpCode = "".obs;
  var termsAgreed = false.obs;
  var errorMessage = "".obs;
  var successMessage = "".obs;

  // Text Editing Controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController createEmailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  // OTP Timer
  Timer? _timer;
  final RxInt _start = 120.obs; // 2 minutes in seconds
  RxString timerText = '02:00'.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎯 AuthController.onInit() started');

    try {
      debugPrint('🔍 Looking for AuthService...');
      authService = Get.find<AuthService>();
      debugPrint('✅ AuthService found and initialized');

      debugPrint('🔍 Looking for TokenStorage...');
      tokenStorage = Get.find<TokenStorage>();
      debugPrint('✅ TokenStorage found and initialized');

      debugPrint('🎉 All services initialized successfully');
    } catch (e) {
      debugPrint('🔥 Error initializing services: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
    }

    debugPrint('🎯 AuthController.onInit() completed');
  }

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
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start.value == 0) {
        timer.cancel();
      } else {
        _start.value--;
        int minutes = _start.value ~/ 60;
        int seconds = _start.value % 60;
        timerText.value =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
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

  // --- API Calls ---

  Future<void> login() async {
    debugPrint('🎯 AuthController.login() started');
    debugPrint('📧 Email input: ${loginEmailController.text}');
    debugPrint('🔒 Password length: ${loginPasswordController.text.length}');

    if (loginEmailController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      debugPrint('❌ Validation failed: Email or password is empty');
      Get.snackbar(
        'Validation Error',
        'Email and password are required',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      debugPrint('🔄 Setting loading state to true');
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      debugPrint('🌐 Calling authService.login()');
      final response = await authService.login(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );

      debugPrint('📨 Login response received');
      debugPrint('✅ Response success: ${response.success}');
      debugPrint('💬 Response message: ${response.message}');
      debugPrint(
        '🔑 Has access token: ${response.data.accessToken.isNotEmpty}',
      );

      if (response.success && response.data.accessToken.isNotEmpty) {
        debugPrint('💾 Saving tokens to storage');
        // Save tokens
        await tokenStorage.saveTokens(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        );
        debugPrint('✅ Tokens saved successfully');

        debugPrint('💾 Saving user data to storage');
        // Save user data
        await tokenStorage.saveUserData(response.data.user.toJson());
        debugPrint('✅ User data saved successfully');

        // Show success toast
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        debugPrint('🚀 Navigating to PersonalizationScreen');
        Get.to(
          () => PersonalizationScreen(),
          binding: PersonalizationBinding(),
        );
      } else {
        debugPrint('❌ Login failed - showing error toast');
        // Show error toast
        Get.snackbar(
          'Login Failed',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('🔥 Exception caught in login: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
      debugPrint('📚 Stack trace: ${StackTrace.current}');

      // Show error toast for exceptions
      Get.snackbar(
        'Login Error',
        'Login failed. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      debugPrint('🔄 Setting loading state to false');
      isLoading.value = false;
      debugPrint('🎯 AuthController.login() completed');
    }
  }

  Future<void> createAccount() async {
    debugPrint('🎯 AuthController.createAccount() started');
    debugPrint('👤 Full name: ${fullNameController.text}');
    debugPrint('📧 Email: ${createEmailController.text}');
    debugPrint('🔒 Password length: ${createPasswordController.text.length}');
    debugPrint(
      '🔒 Confirm password length: ${confirmPasswordController.text.length}',
    );

    if (fullNameController.text.isEmpty ||
        createEmailController.text.isEmpty ||
        createPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      debugPrint('❌ Validation failed: One or more fields are empty');
      Get.snackbar(
        'Validation Error',
        'All fields are required',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (createPasswordController.text != confirmPasswordController.text) {
      debugPrint('❌ Validation failed: Passwords do not match');
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      debugPrint('🔄 Setting loading state to true');
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      debugPrint('🌐 Calling authService.createUser()');
      final response = await authService.createUser(
        name: fullNameController.text,
        email: createEmailController.text,
        password: createPasswordController.text,
      );

      debugPrint('📨 Create user response received');
      debugPrint('✅ Response success: ${response.success}');
      debugPrint('💬 Response message: ${response.message}');

      if (response.success) {
        debugPrint('✅ Account creation successful');
        // Show success toast
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        debugPrint('🚀 Navigating to OTP Screen');
        Get.to(() => OTPScreen()); // Navigate to verification
      } else {
        debugPrint('❌ Account creation failed - showing error toast');
        // Show error toast
        Get.snackbar(
          'Registration Failed',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('🔥 Exception caught in createAccount: ${e.toString()}');
      debugPrint('🔍 Exception type: ${e.runtimeType}');
      debugPrint('📚 Stack trace: ${StackTrace.current}');

      // Show error toast for exceptions
      Get.snackbar(
        'Registration Error',
        'Account creation failed. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      debugPrint('🔄 Setting loading state to false');
      isLoading.value = false;
      debugPrint('🎯 AuthController.createAccount() completed');
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (forgotPasswordEmailController.text.isEmpty) {
      errorMessage.value = 'Email is required';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await authService.forgotPassword(
        email: forgotPasswordEmailController.text,
      );

      if (response.success) {
        successMessage.value = response.message;
        Get.to(() => OTPScreen()); // Navigate to OTP screen
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to send reset email: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (otp.isEmpty) {
      errorMessage.value = 'OTP is required';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await authService.verifyEmail(
        email: createEmailController.text.isNotEmpty
            ? createEmailController.text
            : forgotPasswordEmailController.text,
        oneTimeCode: int.parse(otp),
      );

      if (response.success) {
        successMessage.value = response.message;
        Get.to(() => LoginScreen());
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'OTP verification failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      errorMessage.value = 'Passwords are required';
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        errorMessage.value = 'Authentication token not found';
        return;
      }

      final response = await authService.resetPassword(
        newPassword: newPasswordController.text,
        confirmPassword: confirmNewPasswordController.text,
        token: token,
      );

      if (response.success) {
        successMessage.value = response.message;
        Get.to(() => PasswordChangedScreen()); // Navigate to success screen
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Password reset failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      errorMessage.value = 'All password fields are required';
      return;
    }

    if (newPassword != confirmPassword) {
      errorMessage.value = 'New passwords do not match';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        errorMessage.value = 'Authentication token not found';
        return;
      }

      final response = await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: token,
      );

      if (response.success) {
        successMessage.value = response.message;
        Get.to(() => PasswordChangedScreen());
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to change password: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await tokenStorage.clearAll();
      errorMessage.value = '';
      successMessage.value = '';
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Logout failed: ${e.toString()}';
    }
  }
}
