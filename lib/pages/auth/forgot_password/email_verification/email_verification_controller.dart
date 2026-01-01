import 'dart:convert';

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/auth/login/login_response.dart';
import 'package:buddy/routes/app_pages.dart';

import '../../../../models/error_response.dart';

class EmailVerificationController extends GetxController {
  TextEditingController emailController = TextEditingController();
  bool isForgetPin = false;

  @override
  void onInit() {
    if (Get.arguments != null) {
      isForgetPin = Get.arguments[HttpUtil.isForgetPin];
    }
    super.onInit();
  }

  Future<void> emailVerification() async {
    if (isEmailValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.sendOTP,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          Get.offNamed(Routes.CODE_VERIFICATION, arguments: {
            HttpUtil.email: emailController.text.trim(),
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

  bool isEmailValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    }
    return true;
  }
}
