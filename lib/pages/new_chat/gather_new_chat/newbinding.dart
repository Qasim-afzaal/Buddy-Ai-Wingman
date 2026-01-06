import 'package:get/get.dart';

import 'package:buddy/pages/new_chat/gather_new_chat/controller.dart';

class NewGatherChatInfoBinding extends Bindings {
  // Renamed Binding class
  @override
  void dependencies() {
    Get.lazyPut<NewGatherChatInfoController>(
      // Renamed Controller class
      () => NewGatherChatInfoController(),
    );
  }
}
