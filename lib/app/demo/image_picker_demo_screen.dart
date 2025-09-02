import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/services/image_picker_service.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';

class ImagePickerDemoScreen extends StatefulWidget {
  const ImagePickerDemoScreen({super.key});

  @override
  State<ImagePickerDemoScreen> createState() => _ImagePickerDemoScreenState();
}

class _ImagePickerDemoScreenState extends State<ImagePickerDemoScreen> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.w,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Image Picker Demo',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            
            // Image Display
            Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: 200.w,
                      height: 200.w,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48.w,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'No image selected',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
            
            SizedBox(height: 40.h),
            
            // Select Image Button
            PrimaryButton(
              text: 'Select Image',
              onPressed: () {
                ImagePickerService.showImagePickerBottomSheet(
                  onImageSelected: (File? image) {
                    setState(() {
                      selectedImage = image;
                    });
                  },
                );
              },
            ),
            
            SizedBox(height: 20.h),
            
            // Info Text
            if (selectedImage != null) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Selected Successfully!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Path: ${selectedImage!.path}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const Spacer(),
            
            // Instructions
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'How to use:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Tap "Select Image" to choose from camera or gallery\n'
                    '• You can also remove the current image\n'
                    '• This functionality is integrated into the profile screen',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
