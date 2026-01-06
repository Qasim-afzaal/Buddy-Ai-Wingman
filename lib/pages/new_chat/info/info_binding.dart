import 'package:get/get.dart';
import 'package:buddy/pages/new_chat/info/info_controller.dart';

class InfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoController>(
      () => InfoController(),
    );
  }
}
