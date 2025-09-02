import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              'Last updated: September 2, 2025',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSection(
              'Acceptance of Terms',
              'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.',
            ),
            
            _buildSection(
              'Use License',
              'Permission is granted to temporarily download one copy of the materials on QR Code Inventory for personal, non-commercial transitory viewing only.',
            ),
            
            _buildSection(
              'User Account',
              'You are responsible for safeguarding the password and for all activities that occur under your account. You must immediately notify us of any unauthorized uses of your account.',
            ),
            
            _buildSection(
              'Prohibited Uses',
              'You may not use our service for any illegal or unauthorized purpose nor may you, in the use of the service, violate any laws in your jurisdiction.',
            ),
            
            _buildSection(
              'Products and Services',
              'All purchases through our service are subject to our acceptance. We reserve the right to refuse or cancel your order at any time.',
            ),
            
            _buildSection(
              'Limitation of Liability',
              'In no event shall QR Code Inventory or its suppliers be liable for any damages arising out of the use or inability to use the materials on our service.',
            ),
            
            _buildSection(
              'Changes to Terms',
              'We reserve the right to update these terms at any time without prior notice. Your continued use of the service constitutes acceptance of the new terms.',
            ),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
