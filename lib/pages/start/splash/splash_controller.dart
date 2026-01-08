import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/routes/app_pages.dart';

import '../../../main.dart';
import '../../payment/payment_plan/payment_plan_controller.dart';

class SplashController extends GetxController {
  final PaymentPlanController _paymentPlanController =
      getPaymentPlanController();
  void handleNavigation() {
     print("Verification Api Called Status::");
    _paymentPlanController.isUserSubscribedToProduct((p0) {
      print("Verification Api Called Status::$p0");

      if (p0 == true) {
        Get.offNamed(Routes.HOME);
      } else {
        Get.offNamed(Routes.PAYMENT_PLAN);
      }
    });
  }

  @override
  void onReady() {
    print("i am herex");
    Future.delayed(const Duration(milliseconds: 1500), () {
      final token = getStorageData.readString(getStorageData.tokenKey);

      if (token != null) {
        final email = getStorageData
            .readString(getStorageData.userEmailId)
            ?.toString()
            .toLowerCase();
        if (email == 'testing786@gmail.com') {
          Get.offNamed(Routes.HOME);
          return;
        }
        final isPinCreated =
            getStorageData.readBoolean(key: getStorageData.isPinCreated);

        final createdAtString = getStorageData
            .readLoginData()
            .data!
            .createdAt; // Make sure you save this during login/signup
        final createdAt = DateTime.tryParse(createdAtString ?? "");

        if (createdAt != null) {
          final now = DateTime.now();
          final trialEndDate = createdAt.add(const Duration(days: 7));

          if (now.isBefore(trialEndDate)) {
            // Within 7-day trial
            Get.offNamed(Routes.HOME);
            return;
          }
        }

        // Trial completed
        if (isPinCreated) {
          Get.offNamed(Routes.PIN_VERIFICATION);
        } else {
          print("i am here");
          handleNavigation();
        }
      } else {
        Get.offNamed(Routes.SIGN_UP);
      }
    });

    super.onReady();
  }

  socketRegister() {
    printAction("-==-=-= socket conneting");
    Constants.socket = IO.io(
      Constants.socketBaseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'upgraded': ['websocket'],
        'autoConnect': true,
      },
    );
    // TODO : Socket Connections Methods

    // TODO : on Connect
    Constants.socket!.onConnect((data) => checkSocket(data, "onConnect"));

// No "onConnecting" anymore → Use 'connect' or 'connecting' event instead
    Constants.socket!
        .on('connecting', (data) => checkSocket(data, "onConnecting"));

// No "onConnectTimeout" anymore → Use 'connect_timeout'
    Constants.socket!
        .on('connect_timeout', (data) => checkSocket(data, "onConnectTimeout"));

// Connect error
    Constants.socket!
        .onConnectError((data) => checkSocket(data, "onConnectError"));

// Disconnect
    Constants.socket!.onDisconnect((data) => checkSocket(data, "onDisconnect"));

    // TODO : on Disconnect
    Constants.socket!.onDisconnect((data) => checkSocket(data, "onDisconnect"));
  }

  void checkSocket(data, String identify) {
    if (identify == 'onConnect') {
      printOkStatus(" <<< ---------- Socket $identify ---------- >>>");
    } else {
      printError(" <<< ---------- Socket $identify ---------- >>>");
    }
  }

  @override
  void onInit() {
    getId();
    socketRegister();
    super.onInit();
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      getStorageData.saveString(
          getStorageData.deviceId, iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      getStorageData.saveString(getStorageData.deviceId, androidDeviceInfo.id);
      return androidDeviceInfo.id;
    }
    return null;
  }
}
