import 'package:buddy_ai_wingman/pages/start_sparkd/start_sparkd_controller.dart';
import 'package:get/get.dart';

class Startbuddy_ai_wingmanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Startbuddy_ai_wingmanController>(
      () => Startbuddy_ai_wingmanController(),
    );
  }
}
