import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductDetailsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onFavoriteToggle;
  final RxBool isFavorite;

  const ProductDetailsHeader({
    super.key,
    required this.onBack,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.arrow_back,
                size: 24.w,
                color: Colors.black,
              ),
            ),
          ),
          Obx(() => GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                isFavorite.value ? Icons.favorite : Icons.favorite_outline,
                size: 24.w,
                color: isFavorite.value ? Colors.red : Colors.grey[600],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
