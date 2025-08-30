import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';

class PersonalizationController extends GetxController {
  // Observable variables
  final RxString _selectedProductType = RxString('');
  final RxBool _isButtonEnabled = RxBool(false);
  
  // Getter for the selected product type
  String get selectedProductType => _selectedProductType.value;
  
  // Getter for button state
  bool get isButtonEnabled => _isButtonEnabled.value;
  // A reactive list of products. '.obs' makes it observable.
  final RxList<Product> products = <Product>[
    Product(name: 'Mug', imageUrl: 'https://images.unsplash.com/photo-1510626419826-b5860e6b5286?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8bXVnfHx8fHx8MTcyNDA5MzU3Mw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Hat', imageUrl: 'https://images.unsplash.com/photo-1529958030586-3aae4ca485ff?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8aGF0fHx8fHx8MTcyNDA5MzYxMg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Bag', imageUrl: 'https://images.unsplash.com/photo-1548055230-8c2a343a0c8d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8c3RyYXdfYmFnfHx8fHx8MTcyNDA5MzY0Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Keychains', imageUrl: 'https://images.unsplash.com/photo-1555994223-999335583344?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8a2V5fHx8fHx8MTcyNDA5Mzc2NA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Bag', imageUrl: 'https://images.unsplash.com/photo-1590874102432-9d3215285650?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8dG90ZV9iYWd8fHx8fHwxNzI0MDkzNjk5&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Keychains', imageUrl: 'https://images.unsplash.com/photo-1635422639230-745a72c1c65d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8Y2hyaXN0bWFzX211Z3x8fHx8fDE3MjQwOTM4MjU&ixlib-rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Bag', imageUrl: 'https://images.unsplash.com/photo-1548055230-8c2a343a0c8d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8c3RyYXdfYmFnfHx8fHx8MTcyNDA5MzY0Nw&ixlib-rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
    Product(name: 'Keychains', imageUrl: 'https://images.unsplash.com/photo-1555994223-999335583344?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8a2V5fHx8fHx8MTcyNDA5Mzc2NA&ixlib-rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080'),
  ].obs;

  // Using Rxn<int> allows it to be nullable.
  final Rxn<int> selectedIndex = Rxn<int>();

  // Method to select a product type
  void selectProductType(String productTypeId) {
    _selectedProductType.value = productTypeId;
    _isButtonEnabled.value = true;
  }

  // Method to clear selection
  void clearSelection() {
    _selectedProductType.value = '';
    _isButtonEnabled.value = false;
  }

  // Method to check if a specific product is selected
  bool isProductSelected(String productTypeId) {
    return _selectedProductType.value == productTypeId;
  }
  
  // Called when moving to the next step
  void onNext() {

    print('Selected product type: $_selectedProductType');
  }

  // Method to update the selected index.
  void selectProduct(int index) {
    selectedIndex.value = index;
  }


  
  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 1;
  }

  @override
  void onClose() {
    // Clean up logic if needed
    super.onClose();
  }

}
