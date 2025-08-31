import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/view/dashboard_view.dart';

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
    Product(
      name: 'Mug',
      imageUrl:
          'https://www.bootsphoto.com/cdn/images/t2/fb/T2FBamRuMFZrOWRocWtZRG4yRmVEZVpsSTdRV25qK0dON3czeG1ta1FzcHB2UGlNYWNzR09SYUhScW5MQlNwWnhuaVV3V3A4aXIvZlNBRXduOFU2VTFxSklmOHB1ZCt4L3B0bm5GZjlBREU9.jpg',
    ),
    Product(
      name: 'Hat',
      imageUrl:
          'https://images.unsplash.com/photo-1529958030586-3aae4ca485ff?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8aGF0fHx8fHx8MTcyNDA5MzYxMg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080',
    ),
    Product(
      name: 'Bag',
      imageUrl:
          'https://img.freepik.com/free-psd/ladies-purse-3d-rendering-isometric-icon_47987-9664.jpg',
    ),
    Product(
      name: 'Keychains',
      imageUrl:
          'https://img.drz.lazcdn.com/static/bd/p/960bb809ba8e55e7f98971a742723762.jpg_720x720q80.jpg',
    ),
    Product(
      name: 'Mug',
      imageUrl:
          'https://www.bootsphoto.com/cdn/images/t2/fb/T2FBamRuMFZrOWRocWtZRG4yRmVEZVpsSTdRV25qK0dON3czeG1ta1FzcHB2UGlNYWNzR09SYUhScW5MQlNwWnhuaVV3V3A4aXIvZlNBRXduOFU2VTFxSklmOHB1ZCt4L3B0bm5GZjlBREU9.jpg',
    ),
    Product(
      name: 'Hat',
      imageUrl:
          'https://images.unsplash.com/photo-1529958030586-3aae4ca485ff?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8aGF0fHx8fHx8MTcyNDA5MzYxMg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080',
    ),
    Product(
      name: 'Bag',
      imageUrl:
          'https://img.freepik.com/free-psd/ladies-purse-3d-rendering-isometric-icon_47987-9664.jpg',
    ),
    Product(
      name: 'Keychains',
      imageUrl:
          'https://img.drz.lazcdn.com/static/bd/p/960bb809ba8e55e7f98971a742723762.jpg_720x720q80.jpg',
    ),
  ].obs;

  // Using Rxn<int> allows it to be nullable.
  final Rxn<int> selectedIndex = Rxn<int>();

  // Method to select a product.
  void selectProduct(int index) {
    if (selectedIndex.value == index) {
      // Deselect if the same item is tapped again
      selectedIndex.value = null;
      _isButtonEnabled.value = false;
    } else {
      selectedIndex.value = index;
      _selectedProductType.value = products[index].name;
      _isButtonEnabled.value = true;
    }
  }

  // Called when moving to the next step.
  void onNext() {
    if (isButtonEnabled) {
      Get.offAll(() => DashboardView());
    }
  }
}
