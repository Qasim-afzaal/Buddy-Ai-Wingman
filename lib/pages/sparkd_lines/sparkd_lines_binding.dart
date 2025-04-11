import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_controller.dart';

class SparkdLinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SparkdLinesController>(
      () => SparkdLinesController(),
    );
  }
}
