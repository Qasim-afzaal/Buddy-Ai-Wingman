import 'package:get/get.dart';

import 'package:buddy_ai_wingman/pages/dashboard/dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashBoardController>(
      () => DashBoardController(),
    );
  }
}
