import 'package:get/get.dart';

import 'package:buddy/pages/auth/login/login_controller.dart';

import '../../payment/payment_plan/payment_plan_controller.dart';
import '../../settings/inapp_purchase_source.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
