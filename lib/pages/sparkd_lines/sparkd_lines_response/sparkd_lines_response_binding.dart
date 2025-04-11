import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response_controller.dart';

class SparkdLinesResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SparkdLinesResponseController>(
      () => SparkdLinesResponseController(),
    );
  }
}
