import 'dart:convert';

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/auth/login/login_response.dart';
import 'package:buddy/routes/app_pages.dart';

import '../../../../models/error_response.dart';

class CreatePasswordController extends GetxController {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  bool isChangePasswordValidation() {
    if (utils.isValidationEmpty(newPassword.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyPassword);
      return false;
    } else if (utils.isValidationEmpty(confirmNewPassword.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyConfirmPassword);
      return false;
    } else if (newPassword.text.trim() != confirmNewPassword.text.trim()) {
      utils.showToast(message: AppStrings.errorNotMatchPassword);
      return false;
    }

    return true;
  }

  String? emailValue;
  bool isForgetPin = false;

  @override
  void onInit() {
    if (Get.arguments != null) {
      emailValue = Get.arguments[HttpUtil.email].toString();
      isForgetPin = Get.arguments[HttpUtil.isForgetPin];
    }
    super.onInit();
  }

  Future<void> changePassword() async {
    if (isChangePasswordValidation()) {
      var json = {
        HttpUtil.email: emailValue,
        HttpUtil.password: newPassword.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.forgetPassword,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          utils.showToast(message: mainModel.message!);
          Get.offAllNamed(Routes.LOGIN);
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  Future<void> changePin() async {
    if (isChangePasswordValidation()) {
      var json = {
        HttpUtil.email: getStorageData.readString(getStorageData.userEmailId),
        HttpUtil.pin: newPassword.text.trim(),
        HttpUtil.deviceId: getStorageData.readString(getStorageData.deviceId),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.createPin,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          utils.showToast(message: mainModel.message!);
          Get.offAllNamed(Routes.PIN_VERIFICATION);
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }
}
