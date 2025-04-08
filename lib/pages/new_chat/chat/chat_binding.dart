import 'package:get/get.dart';

import 'package:buddy_ai_wingman/pages/new_chat/chat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
