import 'package:get/get.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationBinding>(
      () => OtpVerificationBinding(),
    );
  }
}
