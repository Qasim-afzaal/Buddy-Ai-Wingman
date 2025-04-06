import 'package:get/get.dart';

import 'package:buddy_ai_wingman/pages/auth/forgot_password/code_verification/code_verification_controller.dart';

class CodeVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CodeVerificationController>(
      () => CodeVerificationController(),
    );
  }
}
