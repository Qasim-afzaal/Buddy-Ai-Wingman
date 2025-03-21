import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/new_chat/info/info_controller.dart';

class InfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoController>(
      () => InfoController(),
    );
  }
}
