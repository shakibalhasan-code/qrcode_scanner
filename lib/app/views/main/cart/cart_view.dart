import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/cart/controller/cart_controller.dart';
import 'package:qr_code_inventory/app/views/main/cart/widgets/cart_item_widget.dart';
import 'package:qr_code_inventory/app/views/main/cart/widgets/cart_bottom_section.dart';
import 'package:qr_code_inventory/app/views/main/cart/widgets/delete_confirmation_dialog.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.onBackPressed,
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
          'My Cart',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            // Select All Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Obx(() => GestureDetector(
                    onTap: controller.toggleSelectAll,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: controller.isSelectAll.value 
                          ? const Color(0xFF003366)
                          : Colors.transparent,
                        border: Border.all(
                          color: controller.isSelectAll.value 
                            ? const Color(0xFF003366)
                            : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: controller.isSelectAll.value
                        ? Icon(
                            Icons.check,
                            size: 14.w,
                            color: Colors.white,
                          )
                        : null,
                    ),
                  )),
                  SizedBox(width: 12.w),
                  Text(
                    'Select All',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Obx(() => Text(
                    'Total Item (${controller.totalItemsCount}Items)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            
            // Cart Items List
            Expanded(
              child: Obx(() => ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.cartItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onToggleSelection: () => controller.toggleItemSelection(item.id),
                    onIncreaseQuantity: () => controller.increaseQuantity(item.id),
                    onDecreaseQuantity: () => controller.decreaseQuantity(item.id),
                    onDelete: () => controller.showDeleteItemDialog(item),
                    onEdit: () => controller.editItem(item),
                  );
                },
              )),
            ),

            // Bottom Section
            Obx(() => CartBottomSection(
              totalAmount: controller.totalAmount,
              selectedItemsCount: controller.selectedItemsCount,
              onCheckout: controller.checkout,
              hasSelectedItems: controller.hasSelectedItems,
            )),
          ],
        );
      }),
      
      // Delete Confirmation Dialog
      bottomNavigationBar: Obx(() => controller.showDeleteDialog.value
        ? DeleteConfirmationDialog(
            onCancel: controller.hideDeleteDialog,
            onDelete: controller.deleteItem,
          )
        : const SizedBox.shrink()),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add some items to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
