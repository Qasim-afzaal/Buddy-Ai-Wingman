import 'package:get/get.dart';
import 'package:buddy/pages/start_sparkd/start_sparkd_controller.dart';

class StartSparkdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartSparkdController>(
      () => StartSparkdController(),
    );
  }
}
