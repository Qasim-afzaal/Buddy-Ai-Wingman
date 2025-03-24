import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/pin/create_pin/create_pin_controller.dart';

class CreatePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePinController>(
      () => CreatePinController(),
    );
  }
}
