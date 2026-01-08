import 'package:get/get.dart';
import 'package:buddy/pages/start/on_boarding_for_social/onBoarding_social_controller.dart';

class OnBoardingSocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingSocialController>(
      () => OnBoardingSocialController(),
    );
  }
}
