import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/product_selection_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class InitialController extends GetxController {
  // Calendar related variables
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);

  /// Current step
  RxInt currentStep = RxInt(0);

  // Total number of steps in the personalization flow
  final RxInt totalSteps = RxInt(2);

  // Product selection related variables (from PersonalizationController)
  final RxString _selectedProductType = RxString('');
  final RxBool _isProductSelectionButtonEnabled = RxBool(false);

  // Getter for the selected product type
  String get selectedProductType => _selectedProductType.value;

  // Getter for button state
  bool get isProductSelectionButtonEnabled =>
      _isProductSelectionButtonEnabled.value;

  @override
  void onInit() {
    super.onInit();
    // Set default selected day to today
    selectedDay.value = DateTime.now();
  }
  /// Manage the section
  void nextSection() {
    // Check if the current step is the last one.
    if (currentStep.value < totalSteps.value - 1) {
      // If not the last step, increment the step.
      currentStep.value++;
    } else {
      // If it is the last step, navigate to the ProductSelectionScreen.
      Get.to(() => ProductSelectionScreen());
    }
  }

  void previousSection() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Product selection methods (from PersonalizationController)
  void selectProductType(String productTypeId) {
    _selectedProductType.value = productTypeId;
    _isProductSelectionButtonEnabled.value = true;
  }

  void clearProductSelection() {
    _selectedProductType.value = '';
    _isProductSelectionButtonEnabled.value = false;
  }

  bool isProductSelected(String productTypeId) {
    return _selectedProductType.value == productTypeId;
  }
}
