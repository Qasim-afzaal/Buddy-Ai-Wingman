import 'package:get/get.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../api_repository/api_class.dart';

class StartSparkdController extends GetxController {
  String? imagePath;
  void addNewChatManually(bool value) {
    Get.toNamed(
      Routes.INFO,
      arguments: {
        if (!value) HttpUtil.filePath: imagePath,
        HttpUtil.isManually: value,
      },
    );
  }
}
