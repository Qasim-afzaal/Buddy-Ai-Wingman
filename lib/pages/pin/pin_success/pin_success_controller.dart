import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/profile/profile_controller.dart';

class PinSuccessController extends GetxController {
  void backToProfile() {
    Get.find<ProfileController>().update();
    Get.back();
  }
}
