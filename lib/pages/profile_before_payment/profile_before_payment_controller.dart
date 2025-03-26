import 'package:get/get.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/constants.dart';

import '../../models/error_response.dart';

class ProfileBeforePaymentController extends GetxController {
  

    Future<void> deleteAccount() async {
     final userid =getStorageData.getUserId();
     print("userid $userid");
    final data = await APIFunction().deleteApiCall(
      apiName: Constants.deleteUser+userid!,
    );
    try {
     getStorageData.removeAllData();
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }
}
