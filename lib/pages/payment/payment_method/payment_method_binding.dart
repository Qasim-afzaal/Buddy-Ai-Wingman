import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_method/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(),
    );
  }
}
