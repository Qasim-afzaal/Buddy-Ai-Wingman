import 'package:get/get.dart';

import 'package:buddy/pages/new_chat/gather_new_chat/gather_new_chat_info_controller.dart';

class GatherNewChatInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GatherNewChatInfoController>(
      () => GatherNewChatInfoController(),
    );
  }
}
