import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/terms_condition/terms_condition_controller.dart';

class TermsConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionController>(
      () => TermsConditionController(),
    );
  }
}
