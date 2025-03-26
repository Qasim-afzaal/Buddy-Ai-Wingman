import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/profile_before_payment/profile_before_payment_controller.dart';

class ProfileBeforePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileBeforePaymentController>(
      () => ProfileBeforePaymentController(),
    );
  }
}
