import 'package:get/get.dart';

import 'package:buddy_ai_wingman/pages/inbox/inbox_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InboxController>(
      () => InboxController(),
    );
  }
}
