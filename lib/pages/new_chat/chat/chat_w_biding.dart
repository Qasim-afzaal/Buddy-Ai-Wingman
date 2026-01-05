import 'package:get/get.dart';

import 'package:buddy/pages/new_chat/chat/chat2_cont.dart';

class Chat2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Chat2Controller>(
      () => Chat2Controller(),
    );
  }
}
