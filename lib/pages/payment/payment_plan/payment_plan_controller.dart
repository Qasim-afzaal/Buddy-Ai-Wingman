import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/models/error_response.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_confirmation/payment_confirmation.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_method/payment_method.dart';
import 'package:buddy_ai_wingman/pages/settings/inapp_purchase_source.dart';

class PaymentPlanController extends GetxController {
  var selectedPlan = ''.obs; // To track the selected subscription plan

  void selectPlan(String plan) {
    selectedPlan.value = plan;
    update(); // Notify listeners
  }

  void onSubscription() {
    // Handle subscription logic based on selectedPlan.value
    if (selectedPlan.isNotEmpty) {
      print("Selected Plan: ${selectedPlan.value}");
      // Implement further subscription logic
    } else {
      print("No plan selected!");
    }
  }

  InAppPurchaseSource inAppPurchaseSource;
  var isLoading = false.obs;
  var isProductSubscribed = false;
  Completer<void>? _subscriptionCompleter;

  PaymentPlanController({required this.inAppPurchaseSource}) {
    inAppPurchaseSource.onLoading = _showLoadingAlert;
    inAppPurchaseSource.isAnimatedLoading = _showAnimationLoadingAlert;
    inAppPurchaseSource.onPurchaseResult = _handlePurchaseResult;
  }

  @override
  void onInit() {
    super.onInit();
    inAppPurchaseSource.initiateStreamSubscription();
  }

  void onSubscriptionPressed() async {
    try {
      await inAppPurchaseSource.subscribeProduct();
    } catch (error) {
      debugPrint("Subscription error: $error");
    }
  }

  void onRestorePurchased(Function(bool) callBack,
      {bool loadingRequired = true}) async {
    _subscriptionCompleter = Completer<void>();
    try {
      Map msg = {"name": " i am in restore ....."};
      Constants.socket!.emit("logEvent", msg);
      inAppPurchaseSource.restorePurchase();
      await _subscriptionCompleter!.future;
      callBack(isProductSubscribed);
    } catch (error) {
      debugPrint("Subscription error: $error");
      callBack(false);
    }
  }

  isUserSubscribedToProduct(Function(bool) callBack,
      {bool loadingRequired = true}) async {
    _subscriptionCompleter = Completer<void>();
    try {
      if (loadingRequired == false) {
        inAppPurchaseSource.isAnimatedLoading = null;
      }
      inAppPurchaseSource.restorePurchase();
      await _subscriptionCompleter!.future;
      callBack(isProductSubscribed);
    } catch (error) {
      debugPrint("Restore error: $error");
      callBack(false);
    }
  }

  void _showLoadingAlert() {
    if (!isLoading.value) {
      print("loading showed...");
      isLoading.value = true;
      EasyLoading.instance.userInteractions = false;
      EasyLoading.show(
        status: "",
        indicator: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.orange,
          size: 50,
        ),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: false,
      );
    }
  }

  void _showAnimationLoadingAlert() {
    if (!isLoading.value) {
      isLoading.value = true;
      EasyLoading.instance.userInteractions = false;
      EasyLoading.show(
        status: "",
        indicator: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.orange,
          size: 50,
        ),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: false,
      );
    }
  }

  void _handlePurchaseResult(PurchaseStatus status, String message,
      {bool isProductSubscribed = false}) {
    if (isLoading.value) {
      print("loading removed...");
      isLoading.value = false;
      Get.back();
      EasyLoading.dismiss();
    }

    switch (status) {
      case PurchaseStatus.error:
        if (message.contains("BillingResponse.itemAlreadyOwned") ||
            message.contains("BillingResponse.developerError")) {
          Get.offAll(() => const PaymentConfirmationPage());
        } else {
          Get.snackbar(
            status == PurchaseStatus.error ? 'Error' : 'Success',
            "Payment Cancel",
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 10),
          );
        }
        break;
      case PurchaseStatus.purchased:
        Get.offAll(() => const PaymentConfirmationPage());
        break;
      case PurchaseStatus.restored:
        this.isProductSubscribed = isProductSubscribed;
        // Complete the completer when restoration is processed
        _subscriptionCompleter?.complete();
        break;
      default:
        Get.snackbar(
          status == PurchaseStatus.error ? 'Error' : 'Success',
          message,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 10),
        );
        break;
    }
  }

  void logoutAccount() async {
    getStorageData.removeAllData();
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
