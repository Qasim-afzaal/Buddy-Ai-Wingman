import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/pin/pin_success/pin_success_controller.dart';

class PinSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinSuccessController>(
      () => PinSuccessController(),
    );
  }
}
