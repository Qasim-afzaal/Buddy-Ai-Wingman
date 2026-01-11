import 'package:get/get.dart';

import 'package:buddy/pages/payment/trial_start/trail_start_controller.dart';

class TrailStartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrailStartController>(
      () => TrailStartController(),
    );
  }
}
