import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controller/initial_controller.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/widgets/personalization_step1.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';
import 'package:qr_code_inventory/app/widgets/secondary_button.dart';

class PersonalizationScreen extends StatelessWidget {
  PersonalizationScreen({super.key});
  final controller = Get.find<InitialController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0.h),
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.stepsSections[controller.currentStep.value],
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text:
                                  'Continue ${controller.currentStep.value + 1}/${controller.stepsSections.length}',
                              onPressed: () {
                                if (controller.currentStep.value <
                                    controller.stepsSections.length - 1) {
                                  controller.nextSection();
                                } else {}
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SecondaryButton(
                              text: 'Skip',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      controller.currentStep.value > 0 ? TextButton(
                        onPressed: () {
                          controller.previousSection();
                        },
                        child: Text('Go to the previous', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
                      ) : SizedBox(),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
