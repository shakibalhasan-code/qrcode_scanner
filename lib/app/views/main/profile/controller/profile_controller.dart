import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/image_picker_service.dart';
import 'package:qr_code_inventory/app/core/services/user_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/core/models/user_model.dart';
import 'package:qr_code_inventory/app/views/auth/signin_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/edit_profile_screen.dart';
import 'package:qr_code_inventory/app/views/main/favourite/favourite_view.dart';
import 'package:qr_code_inventory/app/views/main/notifications/notifications_view.dart';
import 'package:qr_code_inventory/app/views/main/profile/privacy_policy_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/terms_conditions_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/help_support_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/faq_screen.dart';

class ProfileController extends GetxController {
  // Services
  late UserService userService;
  late TokenStorage tokenStorage;

  // User information
  final userProfile = Rxn<User>();
  final userName = 'User'.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userAvatar = ''.obs;
  final selectedProfileImage = Rxn<File>();

  // Loading states
  final isUpdatingProfile = false.obs;
  final isLoadingProfile = false.obs;

  // Profile menu items
  final List<ProfileMenuItem> profileMenuItems = [
    ProfileMenuItem(
      icon: Icons.person_outline,
      title: 'Edit Profile',
      subtitle: 'Name, phone, email',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.notifications_outlined,
      title: 'Notifications',
      subtitle: 'Notification preferences',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.favorite_outline,
      title: 'Wishlist/Favourite',
      subtitle: 'Your saved items',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.policy_outlined,
      title: 'Privacy Policy',
      subtitle: 'How we protect your data',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.article_outlined,
      title: 'Terms & Conditions',
      subtitle: 'Terms of service',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.help_outline,
      title: 'Help & Support',
      subtitle: 'Contact support team',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.quiz_outlined,
      title: 'FAQ',
      subtitle: 'Frequently asked questions',
      onTap: null,
    ),
    ProfileMenuItem(
      icon: Icons.delete_outline,
      title: 'Delete Account',
      subtitle: 'Permanently delete account',
      onTap: null,
      isDelete: true,
    ),
    ProfileMenuItem(
      icon: Icons.logout,
      title: 'Logout',
      subtitle: 'Sign out from app',
      onTap: null,
      isLogout: true,
    ),
  ];

  void onEditProfile() {
    Get.to(() => const EditProfileScreen());
  }

  void onChangeProfileImage() {
    ImagePickerService.showImagePickerBottomSheet(
      onImageSelected: (File? image) async {
        if (image != null) {
          // Update local image immediately for UI feedback
          selectedProfileImage.value = image;

          // Upload image to API immediately
          await _uploadProfileImageToApi(image);
        } else {
          // Remove current image
          selectedProfileImage.value = null;
          await _removeProfileImageFromApi();
        }
      },
    );
  }

  // Upload profile image to API immediately when selected
  Future<void> _uploadProfileImageToApi(File image) async {
    debugPrint('📸 Uploading profile image to API immediately');

    try {
      isUpdatingProfile.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Upload only the image, no other data changes
      final response = await userService.updateUserProfile(
        token: token,
        userData: {}, // Empty data, only uploading image
        profileImage: image,
      );

      if (response.success) {
        // Update local state with API response
        userProfile.value = response.data;
        userAvatar.value = response.data.getFullImageUrl() ?? '';

        debugPrint('✅ Profile image uploaded successfully');

        // Update storage with latest data
        await tokenStorage.saveUserData(response.data.toJson());

        Get.snackbar(
          'Success',
          'Profile photo updated successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in _uploadProfileImageToApi: $e');

      // Revert local image change on failure
      selectedProfileImage.value = null;

      Get.snackbar(
        'Error',
        'Failed to update profile photo: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Remove profile image from API
  Future<void> _removeProfileImageFromApi() async {
    debugPrint('🗑️ Removing profile image from API');

    try {
      isUpdatingProfile.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Send request to remove image (this depends on your API implementation)
      // You might need to send an empty image field or a specific flag
      final response = await userService.updateUserProfileData(
        token: token,
        userData: {'image': ''}, // Set image to empty string to remove
      );

      if (response.success) {
        // Update local state
        userProfile.value = response.data;
        userAvatar.value = '';

        debugPrint('✅ Profile image removed successfully');

        // Update storage
        await tokenStorage.saveUserData(response.data.toJson());

        Get.snackbar(
          'Removed',
          'Profile photo removed successfully',
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in _removeProfileImageFromApi: $e');
      Get.snackbar(
        'Error',
        'Failed to remove profile photo: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Update user profile data only (no image)
  Future<void> updateUserInfo({
    String? name,
    String? email,
    String? phone,
  }) async {
    debugPrint('👤 Updating user profile data in ProfileController');

    try {
      isUpdatingProfile.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Prepare update data
      Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (email != null && email.isNotEmpty) updateData['email'] = email;
      if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;

      if (updateData.isEmpty) {
        throw Exception('No data to update');
      }

      debugPrint('📝 Update data: $updateData');

      final response = await userService.updateUserProfileData(
        token: token,
        userData: updateData,
      );

      if (response.success) {
        // Update local state
        userProfile.value = response.data;
        userName.value = response.data.displayName;
        userEmail.value = response.data.email;
        userPhone.value =
            phone ?? ''; // API doesn't return phone, keep local value

        debugPrint('✅ User profile data updated successfully');

        // Update storage with latest data
        await tokenStorage.saveUserData(response.data.toJson());

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in updateUserInfo: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Update profile with image (multipart upload)
  Future<void> updateProfileWithImage({
    String? name,
    String? email,
    String? phone,
    File? profileImage,
  }) async {
    debugPrint('👤 Updating user profile with image in ProfileController');

    try {
      isUpdatingProfile.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Prepare update data
      Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (email != null && email.isNotEmpty) updateData['email'] = email;
      if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;

      if (updateData.isEmpty && profileImage == null) {
        throw Exception('No data or image to update');
      }

      debugPrint('📝 Update data: $updateData');
      debugPrint('🖼️ Has image: ${profileImage != null}');

      final response = await userService.updateUserProfile(
        token: token,
        userData: updateData,
        profileImage: profileImage,
      );

      if (response.success) {
        // Update local state
        userProfile.value = response.data;
        userName.value = response.data.displayName;
        userEmail.value = response.data.email;
        userPhone.value =
            phone ?? ''; // API doesn't return phone, keep local value

        // Update avatar if image was uploaded
        if (profileImage != null) {
          userAvatar.value = response.data.getFullImageUrl() ?? '';
          selectedProfileImage.value = profileImage; // Keep selected image
        }

        debugPrint('✅ User profile with image updated successfully');

        // Update storage with latest data
        await tokenStorage.saveUserData(response.data.toJson());

        Get.snackbar(
          'Success',
          profileImage != null
              ? 'Profile and photo updated successfully'
              : 'Profile updated successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in updateProfileWithImage: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Convenience method to update profile with current selected image
  Future<void> saveProfileChanges({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (selectedProfileImage.value != null) {
      await updateProfileWithImage(
        name: name,
        email: email,
        phone: phone,
        profileImage: selectedProfileImage.value,
      );
    } else {
      await updateUserInfo(name: name, email: email, phone: phone);
    }
  }

  void onNotificationSettings() {
    Get.to(() => const NotificationsView());
  }

  void onWishlist() {
    Get.to(() => const FavouriteView());
  }

  void onPrivacyPolicy() {
    Get.to(() => const PrivacyPolicyScreen());
  }

  void onTermsAndConditions() {
    Get.to(() => const TermsConditionsScreen());
  }

  void onHelpSupport() {
    Get.to(() => const HelpSupportScreen());
  }

  void onFAQ() {
    Get.to(() => const FAQScreen());
  }

  void onDeleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _performDeleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDeleteAccount() {
    Get.snackbar(
      'Account Deleted',
      'Your account has been permanently deleted',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
    );

    // Navigate to login screen
    Get.offAll(() => const LoginScreen());
  }

  void onLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Clear user data, tokens, etc.
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      duration: const Duration(seconds: 2),
    );

    // Navigate to login screen
    Get.offAll(() => const LoginScreen());
  }

  // Initialize tap handlers
  @override
  void onInit() {
    super.onInit();
    userService = Get.find<UserService>();
    tokenStorage = Get.find<TokenStorage>();
    _initializeMenuHandlers();
    loadUserProfile();
  }

  // Load user profile from API
  Future<void> loadUserProfile() async {
    debugPrint('👤 Loading user profile from API in ProfileController');

    try {
      isLoadingProfile.value = true;

      final token = tokenStorage.getAccessToken();
      if (token == null) {
        debugPrint('❌ No token found for loading user profile');
        _loadUserFromStorage();
        return;
      }

      final response = await userService.getUserProfile(token: token);

      if (response.success) {
        userProfile.value = response.data;
        userName.value = response.data.displayName;
        userEmail.value = response.data.email;
        userPhone.value =
            ''; // API doesn't return phone, keep empty or add to model

        debugPrint(
          '✅ User profile loaded in ProfileController: ${userName.value}',
        );

        // Update storage with latest data
        await tokenStorage.saveUserData(response.data.toJson());
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('💥 Exception in loadUserProfile: $e');
      _loadUserFromStorage();
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // Load user info from storage as fallback
  void _loadUserFromStorage() {
    debugPrint('👤 Loading user info from storage (fallback)');
    try {
      final userData = tokenStorage.getUserData();
      if (userData != null) {
        userName.value = userData['name'] ?? 'User';
        userEmail.value = userData['email'] ?? '';

        // Try to create User object from stored data
        try {
          userProfile.value = User.fromJson(userData);
        } catch (e) {
          debugPrint('⚠️ Could not parse stored user data: $e');
        }
      } else {
        debugPrint('⚠️ No user data found in storage');
      }
    } catch (e) {
      debugPrint('💥 Error loading user info from storage: $e');
    }
  }

  // Method to refresh user profile
  Future<void> refreshUserProfile() async {
    await loadUserProfile();
  }

  void _initializeMenuHandlers() {
    profileMenuItems[0] = profileMenuItems[0].copyWith(onTap: onEditProfile);
    profileMenuItems[1] = profileMenuItems[1].copyWith(
      onTap: onNotificationSettings,
    );
    profileMenuItems[2] = profileMenuItems[2].copyWith(onTap: onWishlist);
    profileMenuItems[3] = profileMenuItems[3].copyWith(onTap: onPrivacyPolicy);
    profileMenuItems[4] = profileMenuItems[4].copyWith(
      onTap: onTermsAndConditions,
    );
    profileMenuItems[5] = profileMenuItems[5].copyWith(onTap: onHelpSupport);
    profileMenuItems[6] = profileMenuItems[6].copyWith(onTap: onFAQ);
    profileMenuItems[7] = profileMenuItems[7].copyWith(onTap: onDeleteAccount);
    profileMenuItems[8] = profileMenuItems[8].copyWith(onTap: onLogout);
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool hasSwitch;
  final bool isLogout;
  final bool isDelete;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.hasSwitch = false,
    this.isLogout = false,
    this.isDelete = false,
  });

  ProfileMenuItem copyWith({
    IconData? icon,
    String? title,
    String? subtitle,
    VoidCallback? onTap,
    bool? hasSwitch,
    bool? isLogout,
    bool? isDelete,
  }) {
    return ProfileMenuItem(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      onTap: onTap ?? this.onTap,
      hasSwitch: hasSwitch ?? this.hasSwitch,
      isLogout: isLogout ?? this.isLogout,
      isDelete: isDelete ?? this.isDelete,
    );
  }
}
