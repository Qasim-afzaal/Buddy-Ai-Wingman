import 'package:get/get.dart';
import 'package:buddy/pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response_controller.dart';

class SparkdLinesResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SparkdLinesResponseController>(
      () => SparkdLinesResponseController(),
    );
  }
}
