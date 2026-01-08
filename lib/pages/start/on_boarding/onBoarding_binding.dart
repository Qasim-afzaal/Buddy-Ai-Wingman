import 'package:get/get.dart';
import 'package:buddy/pages/start/on_boarding/onBoarding_controller.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingController>(
      () => OnBoardingController(),
    );
  }
}
