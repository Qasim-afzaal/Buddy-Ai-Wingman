import 'package:get/get.dart';

import '../../../api_repository/api_class.dart';
import '../../../routes/app_pages.dart';

class InfoController extends GetxController {
  String? filePath;
  bool isManually = false;

  @override
  void onInit() {
    if (Get.arguments != null) {
      isManually = Get.arguments[HttpUtil.isManually];
      if (!isManually) {
        filePath = Get.arguments[HttpUtil.filePath];
      }
    }
    super.onInit();
  }

  void onNext() {
    Get.offNamed(
      Routes.GATHER_NEW_CHAT_INFO,
      arguments: {
        if (!isManually) HttpUtil.filePath: filePath,
        HttpUtil.isManually: isManually,
      },
    );
  }
}
