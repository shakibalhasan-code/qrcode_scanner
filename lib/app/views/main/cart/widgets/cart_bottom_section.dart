import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class CartBottomSection extends StatelessWidget {
  final double totalAmount;
  final int selectedItemsCount;
  final VoidCallback onCheckout;
  final bool hasSelectedItems;

  const CartBottomSection({
    super.key,
    required this.totalAmount,
    required this.selectedItemsCount,
    required this.onCheckout,
    required this.hasSelectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Charge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Charge',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: hasSelectedItems ? onCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasSelectedItems 
                    ? AppColors.primary 
                    : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Checkout Now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: hasSelectedItems ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 20.w,
                      color: hasSelectedItems ? Colors.black : Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
