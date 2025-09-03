import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? expandedIndex;

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I place an order?',
      answer: 'Simply browse the products, select the variant (size, color, etc.), tap "Add to Cart", and proceed to checkout. You\'ll be guided step-by-step to complete your purchase.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept various payment methods including credit cards, debit cards, PayPal, and other digital wallets for your convenience.',
    ),
    FAQItem(
      question: 'How do I track my order?',
      answer: 'Once your order is confirmed, you\'ll receive a tracking number via email. You can use this number to track your order status in real-time.',
    ),
    FAQItem(
      question: 'How do I track my order?',
      answer: 'Once your order is confirmed, you\'ll receive a tracking number via email. You can use this number to track your order status in real-time.',
    ),
    FAQItem(
      question: 'Can I cancel or change my order?',
      answer: 'You can cancel or modify your order within 24 hours of placing it. After this period, changes may not be possible as the order enters processing.',
    ),
    FAQItem(
      question: 'How long does shipping take?',
      answer: 'Shipping typically takes 3-7 business days for domestic orders and 7-14 business days for international orders, depending on your location.',
    ),
    FAQItem(
      question: 'How do I return a product?',
      answer: 'You can return products within 30 days of delivery. Items must be in original condition with tags attached. Contact our support team to initiate a return.',
    ),
    FAQItem(
      question: 'Where can I find my vouchers?',
      answer: 'Your vouchers can be found in the "My Account" section under "Vouchers" or "Coupons". Active vouchers will be automatically applied at checkout.',
    ),
    FAQItem(
      question: 'What is Shopivia Wallet?',
      answer: 'Shopivia Wallet is our digital wallet feature that allows you to store money for faster checkout, receive cashback, and manage your spending within the app.',
    ),
    FAQItem(
      question: 'Why can\'t I apply my voucher?',
      answer: 'Vouchers may have specific terms and conditions such as minimum purchase amount, expiry dates, or product restrictions. Please check the voucher details.',
    ),
  ];

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
          'FAQ\'s',
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
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'This FAQ\'s last updated was 8 May 2025',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              
              // FAQ Items
              ...faqItems.asMap().entries.map((entry) {
                int index = entry.key;
                FAQItem item = entry.value;
                bool isExpanded = expandedIndex == index;
                
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.question,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                                size: 24.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Divider(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Text(
                            item.answer,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              
              SizedBox(height: 32.h),
              
              // Still have questions section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Still have unanswered questions?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _contactSupport(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.black,
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
                              'Let\'s Talk Now',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactSupport() {
    Get.back(); // Go back to help & support screen
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
