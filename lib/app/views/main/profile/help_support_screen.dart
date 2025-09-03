import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/profile/faq_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20.sp,
            ),
          ),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Section
              Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your top up transaction successfully added, let\'s go !',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              
              // Contact Options
              Row(
                children: [
                  Expanded(
                    child: _buildContactOption(
                      icon: Icons.phone,
                      title: 'Phone Number',
                      value: '+318914897',
                      onTap: () => _launchPhone('+318914897'),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildContactOption(
                      icon: Icons.chat,
                      title: 'Whatsapp Number',
                      value: '+62 8123 4567 890',
                      onTap: () => _launchWhatsApp('+6281234567890'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              Row(
                children: [
                  Expanded(
                    child: _buildContactOption(
                      icon: Icons.language,
                      title: 'Website',
                      value: 'shopivia.co',
                      onTap: () => _launchWebsite('https://shopivia.co'),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildContactOption(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'hello@shopivia.co',
                      onTap: () => _launchEmail('hello@shopivia.co'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48.h),
              
              // Report a Problem Section
              Text(
                'Report a Problem',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Do you have any problem or issues on your experience & adventure? let us know below',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Report Button
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1E3A8A)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ElevatedButton(
                  onPressed: () => _reportProblem(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF1E3A8A),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Report it & Let\'s Discuss',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.phone,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              
              // FAQ Section
              InkWell(
                onTap: () => Get.to(() => const FAQScreen()),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: const Color(0xFF1E3A8A),
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Our FAQ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Let\'s find out the answer of your question',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1E3A8A),
                size: 24.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    // final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    // if (await canLaunchUrl(phoneUri)) {
    //   await launchUrl(phoneUri);
    // }
  }

  void _launchWhatsApp(String phoneNumber) async {
    // final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    // if (await canLaunchUrl(whatsappUri)) {
    //   await launchUrl(whatsappUri);
    // }
  }

  void _launchWebsite(String url) async {
    final Uri websiteUri = Uri.parse(url);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri);
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _reportProblem() {
    _launchPhone('+318914897');
  }
}
