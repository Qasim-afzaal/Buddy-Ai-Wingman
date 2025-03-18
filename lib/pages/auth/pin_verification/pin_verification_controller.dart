import 'dart:convert';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../models/error_response.dart';

class PinVerificationController extends GetxController {
  TextEditingController pinController = TextEditingController();

  // bool isPinValidation() {
  //   if (utils.isValidationEmpty(pinController.text.trim())) {
  //     utils.showToast(message: AppStrings.errorEmptyPin);
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> loginWithPin() async {
    // if (isPinValidation()) {
    var json = {
      HttpUtil.pin: pinController.text.trim(),
      HttpUtil.deviceId: getStorageData.readString(getStorageData.deviceId),
    };
    final data = await APIFunction().apiCall(
      apiName: Constants.loginByPin,
      withOutFormData: jsonEncode(json),
    );
    try {
      LoginResponse mainModel = LoginResponse.fromJson(data);
      if (mainModel.success!) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }
  // }
}
