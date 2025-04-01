import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/start/splash/splash_controller.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
