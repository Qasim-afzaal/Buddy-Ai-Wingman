import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response_controller.dart';
import 'package:get/get.dart';

class buddy_ai_wingmanLinesResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<buddy_ai_wingmanLinesResponseController>(
      () => buddy_ai_wingmanLinesResponseController(),
    );
  }
}
