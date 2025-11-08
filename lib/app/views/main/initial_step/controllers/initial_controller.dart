import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/product_selection_screen.dart';
import 'package:qr_code_inventory/app/core/services/auth_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class InitialController extends GetxController {
  // Services
  late AuthService authService;
  late TokenStorage tokenStorage;

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Calendar related variables
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);

  /// Current step
  RxInt currentStep = RxInt(0);

  // Total number of steps in the personalization flow
  final RxInt totalSteps = RxInt(2);

  // Product selection related variables (from PersonalizationController)
  final RxString _selectedProductType = RxString('');
  final RxBool _isProductSelectionButtonEnabled = RxBool(false);

  // Loading state
  var isLoading = false.obs;

  // Getter for the selected product type
  String get selectedProductType => _selectedProductType.value;

  // Getter for button state
  bool get isProductSelectionButtonEnabled =>
      _isProductSelectionButtonEnabled.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎯 InitialController.onInit() started');

    try {
      authService = Get.find<AuthService>();
      tokenStorage = Get.find<TokenStorage>();
      debugPrint('✅ Services found and initialized');

      // Auto-populate user data if available
      _loadUserData();
    } catch (e) {
      debugPrint('⚠️ Services not found, initializing...');
      // Initialize services if they don't exist
      Get.put<TokenStorage>(TokenStorage(), permanent: true);
      Get.put<AuthService>(AuthService(), permanent: true);
      authService = Get.find<AuthService>();
      tokenStorage = Get.find<TokenStorage>();

      // Try to load user data after initializing services
      _loadUserData();
    }

    // Set default selected day to today
    selectedDay.value = DateTime.now();
    debugPrint('🎯 InitialController.onInit() completed');
  }

  void _loadUserData() {
    try {
      debugPrint('📋 Loading saved user data...');

      // Check if token exists
      final token = tokenStorage.getAccessToken();
      debugPrint('🎫 Token exists: ${token != null}');

      // Get saved user data
      final userData = tokenStorage.getUserData();
      if (userData != null) {
        debugPrint('👤 User data found: ${userData.toString()}');

        // Auto-populate fields with saved data
        if (userData['name'] != null && nameController.text.isEmpty) {
          nameController.text = userData['name'];
          debugPrint('📝 Auto-populated name: ${userData['name']}');
        }

        if (userData['email'] != null && emailController.text.isEmpty) {
          emailController.text = userData['email'];
          debugPrint('📧 Auto-populated email: ${userData['email']}');
        }
      } else {
        debugPrint('❌ No user data found in storage');
      }
    } catch (e) {
      debugPrint('💥 Error loading user data: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Manage the section
  void nextSection() {
    debugPrint('🔄 nextSection() called - Current step: ${currentStep.value}');

    // Validate current step before proceeding
    if (currentStep.value == 0) {
      // Validate step 1 (name and email)
      if (nameController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter your name');
        return;
      }
      if (emailController.text.trim().isEmpty ||
          !emailController.text.contains('@')) {
        Get.snackbar('Error', 'Please enter a valid email');
        return;
      }
    }

    // Check if the current step is the last one.
    if (currentStep.value < totalSteps.value - 1) {
      // If not the last step, increment the step.
      currentStep.value++;
      debugPrint('📍 Moved to step: ${currentStep.value}');
    } else {
      // If it is the last step, create personalization and navigate
      createPersonalization();
    }
  }

  // Debug method to check storage state
  void debugTokenStorage() {
    debugPrint('� === TOKEN STORAGE DEBUG ===');
    try {
      final token = tokenStorage.getAccessToken();
      final refreshToken = tokenStorage.getRefreshToken();
      final userData = tokenStorage.getUserData();
      final isLoggedIn = tokenStorage.isLoggedIn();

      debugPrint(
        '🎫 Access Token: ${token != null ? 'EXISTS (${token.length} chars)' : 'NULL'}',
      );
      debugPrint(
        '🔄 Refresh Token: ${refreshToken != null ? 'EXISTS (${refreshToken.length} chars)' : 'NULL'}',
      );
      debugPrint('👤 User Data: ${userData != null ? 'EXISTS' : 'NULL'}');
      debugPrint('✅ Is Logged In: $isLoggedIn');

      if (userData != null) {
        debugPrint('📧 Stored Email: ${userData['email']}');
        debugPrint('👤 Stored Name: ${userData['name']}');
      }

      if (token != null && token.length > 20) {
        debugPrint('🔑 Token Preview: ${token.substring(0, 20)}...');
      }
    } catch (e) {
      debugPrint('💥 Error in debug: $e');
    }
    debugPrint('🔍 === END TOKEN STORAGE DEBUG ===');
  }

  // Create personalization profile
  Future<void> createPersonalization() async {
    debugPrint('� createPersonalization() called');

    // Debug token storage first
    debugTokenStorage();

    // Validate form data
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        selectedDay.value == null) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    try {
      isLoading.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ No valid token found in storage');
        Get.snackbar(
          'Error',
          'Authentication token not found. Please login again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        // Clear any corrupt data and redirect to login
        await tokenStorage.clearAll();
        Get.offAllNamed('/login');
        return;
      }

      // Use default category ID from API documentation
      const String categoryToUse = "68a2f80cdf1f41fbc82b66ba";
      debugPrint('🏷️ Using default category ID: $categoryToUse');

      debugPrint('📋 Form Data:');
      debugPrint('👤 Name: ${nameController.text.trim()}');
      debugPrint('📧 Email: ${emailController.text.trim()}');
      debugPrint('📅 Birthday: ${selectedDay.value}');
      debugPrint('🏷️ Category: $categoryToUse');

      final response = await authService.createPersonalization(
        category: categoryToUse,
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        birthday: selectedDay.value!,
        token: token,
      );

      if (response.success) {
        debugPrint('✅ Personalization created successfully');
        Get.snackbar('Success', response.message);
        Get.to(() => ProductSelectionScreen());
      } else {
        debugPrint('❌ Failed to create personalization: ${response.message}');
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in createPersonalization: $e');
      Get.snackbar(
        'Error',
        'Failed to create personalization: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void previousSection() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Product selection methods (from PersonalizationController)
  void selectProductType(String productTypeId) {
    _selectedProductType.value = productTypeId;
    _isProductSelectionButtonEnabled.value = true;
  }

  void clearProductSelection() {
    _selectedProductType.value = '';
    _isProductSelectionButtonEnabled.value = false;
  }

  bool isProductSelected(String productTypeId) {
    return _selectedProductType.value == productTypeId;
  }
}
