import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/profile/profile_controller.dart';

class PinSuccessController extends GetxController {
  void backToProfile() {
    Get.find<ProfileController>().update();
    Get.back();
  }
}
