import 'package:get/get.dart';

import 'package:buddy/pages/home/image_chat/screen/image_chat_controller.dart';

class PickupLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageChatController>(
      () => ImageChatController(),
    );
  }
}
