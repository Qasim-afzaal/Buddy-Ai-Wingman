import 'package:get/get.dart';

import 'package:buddy/pages/home/manual_chat/manual_chat_controller.dart';

class ManualChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualChatPageController>(
      () => ManualChatPageController(),
    );
  }
}
