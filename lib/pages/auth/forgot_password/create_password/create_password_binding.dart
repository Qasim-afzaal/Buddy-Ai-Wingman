import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/auth/forgot_password/create_password/create_password_controller.dart';

class CreatePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePasswordController>(
      () => CreatePasswordController(),
    );
  }
}
