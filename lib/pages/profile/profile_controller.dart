import 'package:get/get.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/constants.dart';
import 'package:buddy_ai_wingman/pages/profile/clear_all_chat_response.dart';

import '../../models/error_response.dart';
import '../inbox/inbox_controller.dart';

class ProfileController extends GetxController {
  void deleteAllChat() async {
    final data = await APIFunction().deleteApiCall(
      apiName: Constants.clearAll,
    );
    try {
      ClearAllChatResponse mainModel = ClearAllChatResponse.fromJson(data);
      if (mainModel.success!) {
        Get.find<InboxController>().callChatList(
            Get.find<InboxController>().selectedType.value, false);
        utils.showToast(message: mainModel.message!);
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }

  void deleteAccount() async {
    final userid = getStorageData.getUserId();
    print("userid $userid");
    final data = await APIFunction().deleteApiCall(
      apiName: Constants.deleteUser + userid!,
    );
    try {
      getStorageData.removeAllData();
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }
}
