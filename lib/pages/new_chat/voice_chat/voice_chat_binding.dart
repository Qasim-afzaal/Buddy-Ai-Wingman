import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/new_chat/voice_chat/voice_chat_controller.dart';

class VoiceChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceChatController>(
      () => VoiceChatController(),
    );
  }
}
