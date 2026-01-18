import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:buddy/core/services/onesignal_service.dart';
import 'package:buddy/pages/auth/login/login_response.dart';
import 'package:buddy/routes/app_pages.dart';

/// Storage utility class for local data persistence
class GetStorageData {
  String loginData = "loginData";
  String type = "type";
  String saveData = "SaveData";
  String userName = "useName";
  String userEmailId = "userEmailId";
  String userIdKey = "user_id";
  String tokenKey = "token";
  String deviceId = "device_id";
  String isPinCreated = "is_pin_created";

  /// <<< To save object data --------- >>>
  saveString(String key, value) async {
    final box = GetStorage();
    return box.write(key, value);
  }

  /// <<< To read object data --------- >>>
  readString(String key) {
    final box = GetStorage();
    if (box.hasData(key)) {
      return box.read(key);
    } else {
      return null;
    }
  }

  /// <<< To save boolean data --------- >>>
  saveBoolean({
    required String key,
    required bool value,
  }) async {
    final box = GetStorage();
    return box.write(key, value);
  }

  /// <<< To read boolean data --------- >>>
  bool readBoolean({required String key}) {
    bool isValue = false;
    final box = GetStorage();

    if (box.hasData(key)) {
      isValue = box.read(key) ?? false;
    }
    return isValue;
  }

  /// <<< To Store Key data --------- >>>
  bool containKey(String key) {
    final box = GetStorage();
    return box.hasData(key);
  }

  saveLoginData(LoginResponse value) {
    final box = GetStorage();
    String allData = jsonEncode(value);
    box.write(loginData, allData);

    saveString(userIdKey, value.data?.id);
    saveString(tokenKey, value.data?.accessToken);
    saveString(userName, value.data?.name);
    saveString(userEmailId, value.data?.email);
  }

  String? getUserId() {
    final box = GetStorage();
    return box.read(userIdKey);
  }

  LoginResponse readLoginData() {
    if (containKey(loginData)) {
      final box = GetStorage();
      var result = box.read(loginData);
      return LoginResponse.fromJson(jsonDecode(result));
    } else {
      return LoginResponse();
    }
  }

  /// <<< To remove data --------- >>>
  removeData(String key) async {
    final box = GetStorage();
    return box.remove(key);
  }

  saveObject(String key, value) {
    final box = GetStorage();
    String allData = jsonEncode(value);
    box.write(key, allData);
  }

  readObject(String key) {
    final box = GetStorage();
    var result = box.read(key);
    return jsonDecode(result);
  }

  removeLoginData() {
    removeData(loginData);
    removeData(userIdKey);
    removeData(tokenKey);
  }

  removeAllData() async {
    await removeData(loginData);
    await removeData(type);
    await removeData(saveData);
    await removeData(userName);
    await removeData(userEmailId);
    await removeData(userIdKey);
    await removeData(tokenKey);
    await removeData(isPinCreated);

    // Logout from OneSignal
    try {
      await OneSignalService.instance.logout();
    } catch (e) {
      debugPrint('Error logging out from OneSignal: $e');
    }

    removeLoginData();
    Get.offAllNamed(Routes.LOGIN);
  }
}

