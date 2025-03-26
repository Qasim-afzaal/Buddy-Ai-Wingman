import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_controller.dart';
import 'package:get/get.dart';

class buddy_ai_wingmanLinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<buddy_ai_wingmanLinesController>(
      () => buddy_ai_wingmanLinesController(),
    );
  }
}
