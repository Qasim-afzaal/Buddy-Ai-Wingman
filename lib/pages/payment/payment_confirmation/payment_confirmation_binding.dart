import 'package:get/get.dart';
import 'package:buddy/pages/payment/payment_confirmation/payment_confirmation_controller.dart';

class PaymentConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentConfirmationController>(
      () => PaymentConfirmationController(),
    );
  }
}
