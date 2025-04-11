import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/start_sparkd/start_sparkd_controller.dart';

class StartSparkdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartSparkdController>(
      () => StartSparkdController(),
    );
  }
}
