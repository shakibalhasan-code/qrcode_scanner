import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/widgets/personalization_step1.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/widgets/personalization_step2.dart';
import 'package:table_calendar/table_calendar.dart';

class InitialController extends GetxController {
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);

  /// Current step
  RxInt currentStep = RxInt(0);

  // Use a method to initialize the steps after the controller is fully initialized
  late RxList<Widget> stepsSections;
  
  @override
  void onInit() {
    super.onInit();
    // Set default selected day to today
    selectedDay.value = DateTime.now();
    // Initialize steps after controller is fully created
    stepsSections = [PersonalizationStep1(), PersonalizationStep2()].obs;
  }

  /// Manage the section
  void nextSection() {
    if (currentStep.value < stepsSections.length - 1) {
      currentStep.value++;
    }
  }

  void previousSection() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}