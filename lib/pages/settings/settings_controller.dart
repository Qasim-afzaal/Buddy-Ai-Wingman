import 'dart:async';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/settings/inapp_purchase_source.dart';

class SettingsController extends GetxController {
  InAppPurchaseSource inAppPurchaseSource;
  var isLoading = false.obs;
  var isProductSubscribed = false;
  Completer<void>? _subscriptionCompleter;

  SettingsController({required this.inAppPurchaseSource}) {
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

  isUserSubscribedToProduct(Function(bool) callBack) async {
    _subscriptionCompleter = Completer<void>();
    try {
      inAppPurchaseSource.restorePurchase();
      await _subscriptionCompleter!.future;
      // After restoration, call the callback with the subscription status
      callBack(isProductSubscribed);
    } catch (error) {
      debugPrint("Restore error: $error");
      callBack(false);
    }
  }

  void _showLoadingAlert() {
    if (!isLoading.value) {
      isLoading.value = true;
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Processing...'),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void _showAnimationLoadingAlert() {
    if (!isLoading.value) {
      isLoading.value = true;
    }
  }

  void _handlePurchaseResult(PurchaseStatus status, String message,
      {bool isProductSubscribed = false}) {
    if (isLoading.value) {
      isLoading.value = false;
      Get.back();
    }

    switch (status) {
      case PurchaseStatus.error:
      case PurchaseStatus.purchased:
        Get.snackbar(
          status == PurchaseStatus.error ? 'Error' : 'Success',
          message,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 10),
        );
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
}
