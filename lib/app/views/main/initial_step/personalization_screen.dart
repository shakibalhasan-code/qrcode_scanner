import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controllers/initial_controller.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/product_selection_screen.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/widgets/personalization_step1.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/widgets/personalization_step2.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';
import 'package:qr_code_inventory/app/widgets/secondary_button.dart';

class PersonalizationScreen extends StatelessWidget {
  PersonalizationScreen({super.key});
  final controller = Get.find<InitialController>();

  // Method to build the current step widget based on the step index
  Widget _buildCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return const PersonalizationStep1();
      case 1:
        return PersonalizationStep2();

      default:
        return const PersonalizationStep1(); // Default to first step
    }
  }

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
                      // Dynamically show the appropriate step based on currentStep
                      _buildCurrentStep(controller.currentStep.value),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => PrimaryButton(
                                text: controller.isLoading.value
                                    ? 'Loading...'
                                    : 'Continue ${controller.currentStep.value + 1}/${controller.totalSteps.value}',
                                onPressed: controller.isLoading.value
                                    ? () {}
                                    : controller.nextSection,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: SecondaryButton(
                              text: 'Skip',
                              onPressed: () {
                                Get.to(ProductSelectionScreen());
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      controller.currentStep.value > 0
                          ? TextButton(
                              onPressed: () {
                                controller.previousSection();
                              },
                              child: Text(
                                'Go to the previous',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : SizedBox(),
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
