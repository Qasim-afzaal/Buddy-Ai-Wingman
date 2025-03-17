import 'dart:convert';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../../models/error_response.dart';

class CodeVerificationController extends GetxController {
  TextEditingController otpController = TextEditingController();
  String? emailValue;
  bool isForgetPin = false;

  @override
  void onInit() {
    if (Get.arguments != null) {
      emailValue = Get.arguments[HttpUtil.email].toString();
    }
    super.onInit();
  }

  Future<void> codeVerification() async {
    if (isOTPValidation()) {
      var json = {
        HttpUtil.email: emailValue,
        HttpUtil.otp: otpController.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.verifyOTP,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          Get.offNamed(Routes.CREATE_PASSWORD, arguments: {
            HttpUtil.email: emailValue,
            HttpUtil.isForgetPin: isForgetPin,
          });
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  bool isOTPValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(otpController.text)) {
      utils.showToast(message: AppStrings.errorOTP);
      return false;
    } else if (otpController.text.length != 4) {
      utils.showToast(message: AppStrings.errorValidOTP);
      return false;
    }
    return true;
  }
}
