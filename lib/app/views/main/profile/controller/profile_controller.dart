import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/image_picker_service.dart';
import 'package:qr_code_inventory/app/views/auth/signin_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/edit_profile_screen.dart';
import 'package:qr_code_inventory/app/views/main/favourite/favourite_view.dart';
import 'package:qr_code_inventory/app/views/main/notifications/notifications_view.dart';
import 'package:qr_code_inventory/app/views/main/profile/privacy_policy_screen.dart';
import 'package:qr_code_inventory/app/views/main/profile/terms_conditions_screen.dart';
  
class ProfileController extends GetxController {
  // User information
  final userName = 'Alexander Putra'.obs;
  final userEmail = 'alexander.putra@email.com'.obs;
  final userPhone = '+1 234 567 8900'.obs;
  final userAvatar = ''.obs; // Can be empty for placeholder
  final selectedProfileImage = Rxn<File>(); // For storing selected image

  // Loading states
  final isUpdatingProfile = false.obs;

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
      onImageSelected: (File? image) {
        if (image != null) {
          selectedProfileImage.value = image;
          Get.snackbar(
            'Success',
            'Profile photo updated successfully',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Remove current image
          selectedProfileImage.value = null;
          Get.snackbar(
            'Removed',
            'Profile photo removed',
            duration: const Duration(seconds: 2),
          );
        }
      },
    );
  }

  void updateUserInfo({
    String? name,
    String? email,
    String? phone,
  }) {
    isUpdatingProfile.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      if (name != null) userName.value = name;
      if (email != null) userEmail.value = email;
      if (phone != null) userPhone.value = phone;
      
      isUpdatingProfile.value = false;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );
    });
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

  void onDeleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
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
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
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
    _initializeMenuHandlers();
  }

  void _initializeMenuHandlers() {
    profileMenuItems[0] = profileMenuItems[0].copyWith(onTap: onEditProfile);
    profileMenuItems[1] = profileMenuItems[1].copyWith(onTap: onNotificationSettings);
    profileMenuItems[2] = profileMenuItems[2].copyWith(onTap: onWishlist);
    profileMenuItems[3] = profileMenuItems[3].copyWith(onTap: onPrivacyPolicy);
    profileMenuItems[4] = profileMenuItems[4].copyWith(onTap: onTermsAndConditions);
    profileMenuItems[5] = profileMenuItems[5].copyWith(onTap: onDeleteAccount);
    profileMenuItems[6] = profileMenuItems[6].copyWith(onTap: onLogout);
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
