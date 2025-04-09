import 'dart:convert';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../models/error_response.dart';

class CreatePinController extends GetxController {
  TextEditingController oldPin = TextEditingController();
  TextEditingController newPin = TextEditingController();
  TextEditingController confirmNewPin = TextEditingController();

  bool isNewPinValidation() {
    if (utils.isValidationEmpty(newPin.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyPin);
      return false;
    } else if (utils.isValidationEmpty(confirmNewPin.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyConfirmPin);
      return false;
    } else if (newPin.text.trim() != confirmNewPin.text.trim()) {
      utils.showToast(message: AppStrings.errorNotMatchPin);
      return false;
    }

    return true;
  }

  bool isChangePinValidation() {
    if (utils.isValidationEmpty(oldPin.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyPin);
      return false;
    } else if (utils.isValidationEmpty(newPin.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyNewPin);
      return false;
    } else if (utils.isValidationEmpty(confirmNewPin.text.trim())) {
      utils.showToast(message: AppStrings.errorEmptyConfirmPin);
      return false;
    } else if (newPin.text.trim() != confirmNewPin.text.trim()) {
      utils.showToast(message: AppStrings.errorNotMatchPin);
      return false;
    }

    return true;
  }

  Future<void> createPin() async {
    if (isNewPinValidation()) {
      var json = {
        HttpUtil.email: getStorageData.readString(getStorageData.userEmailId),
        HttpUtil.pin: newPin.text.trim(),
        HttpUtil.deviceId: getStorageData.readString(getStorageData.deviceId),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.createPin,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          getStorageData.saveBoolean(
              key: getStorageData.isPinCreated, value: true);
          utils.showToast(message: mainModel.message!);
          Get.offNamed(Routes.PIN_SUCCESS);
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
    if (isChangePinValidation()) {
      var json = {
        HttpUtil.email: getStorageData.readString(getStorageData.userEmailId),
        HttpUtil.newPin: newPin.text.trim(),
        HttpUtil.oldPin: oldPin.text.trim(),
        HttpUtil.deviceId: getStorageData.readString(getStorageData.deviceId),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.updatePin,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          utils.showToast(message: mainModel.message!);
          Get.back();
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
