import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/core/models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onToggleSelection;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onToggleSelection,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggleSelection,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: item.isSelected ? const Color(0xFF003366) : Colors.transparent,
                    border: Border.all(
                      color: item.isSelected ? const Color(0xFF003366) : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: item.isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.w,
                        color: Colors.white,
                      )
                    : null,
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Product Name (top right)
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              // Product Image
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _buildProductImage(),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Size and Color
                    Row(
                      children: [
                        Text(
                          'Size : ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          item.size ?? '-',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'Color : ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          item.color ?? '-',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Quantity Controls and Price
                    Row(
                      children: [
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: onDecreaseQuantity,
                                child: Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF003366),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 16.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              
                              Container(
                                width: 40.w,
                                alignment: Alignment.center,
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              
                              GestureDetector(
                                onTap: onIncreaseQuantity,
                                child: Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF003366),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Price
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Action Buttons at bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[100],
                  //   borderRadius: BorderRadius.circular(8.r),
                  // ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 20.w,
                    color: Colors.red[600],
                  ),
                ),
              ),
              
              // SizedBox(width: 12.w),
              
              // GestureDetector(
              //   onTap: onEdit,
              //   child: Container(
              //     padding: EdgeInsets.all(8.w),
              //     // decoration: BoxDecoration(
              //     //   color: Colors.grey[100],
              //     //   borderRadius: BorderRadius.circular(8.r),
              //     // ),
              //     child: Icon(
              //       Icons.edit_outlined,
              //       size: 20.w,
              //       color: Colors.grey[600],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (item.image.startsWith('http')) {
      return Image.network(
        item.image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    } else {
      return Image.asset(
        item.image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        size: 24.w,
        color: Colors.grey[400],
      ),
    );
  }
}
