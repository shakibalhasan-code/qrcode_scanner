import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet with image picker options
  static void showImagePickerBottomSheet({
    required Function(File?) onImageSelected,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Text(
              'Select Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Camera option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                ),
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to take a new photo'),
              onTap: () {
                Get.back();
                _pickImageFromCamera(onImageSelected);
              },
            ),
            
            // Gallery option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Colors.green,
                ),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select from your photo library'),
              onTap: () {
                Get.back();
                _pickImageFromGallery(onImageSelected);
              },
            ),
            
            // Remove photo option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              title: const Text('Remove Photo'),
              subtitle: const Text('Remove current profile photo'),
              onTap: () {
                Get.back();
                onImageSelected(null);
              },
            ),
            
            const SizedBox(height: 10),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Pick image from camera
  static Future<void> _pickImageFromCamera(Function(File?) onImageSelected) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      
      if (image != null) {
        onImageSelected(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Pick image from gallery
  static Future<void> _pickImageFromGallery(Function(File?) onImageSelected) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      
      if (image != null) {
        onImageSelected(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select photo: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Pick multiple images from gallery
  static Future<void> pickMultipleImages({
    required Function(List<File>) onImagesSelected,
    int? maxImages,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      
      if (images.isNotEmpty) {
        List<File> files = images.map((xFile) => File(xFile.path)).toList();
        
        // Limit the number of images if specified
        if (maxImages != null && files.length > maxImages) {
          files = files.take(maxImages).toList();
          Get.snackbar(
            'Limit Reached',
            'Only first $maxImages images were selected',
            duration: const Duration(seconds: 2),
          );
        }
        
        onImagesSelected(files);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select images: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
