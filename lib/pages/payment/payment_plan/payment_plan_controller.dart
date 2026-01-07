import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/core/services/payment_api_service.dart';
import 'package:buddy/models/error_response.dart';
import 'package:buddy/pages/settings/inapp_purchase_source.dart';
import 'package:buddy/pages/settings/revenuecat_purchase_source.dart';
import 'package:buddy/routes/app_pages.dart';

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

  void onSubscriptionPressed(String productId) async {
    try {
      await inAppPurchaseSource.subscribeProduct(productId);
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
      
      // For RevenueCat, try direct check first (faster and more reliable)
      if (inAppPurchaseSource is RevenueCatPurchaseSourceImpl) {
        debugPrint("🔍 Using RevenueCat direct subscription check...");
        // Wait a bit for RevenueCat to sync after app start
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Try direct check first (checks both entitlements and active subscriptions)
        final revenueCatSource = inAppPurchaseSource as RevenueCatPurchaseSourceImpl;
        final isSubscribed = await revenueCatSource.checkSubscriptionStatusDirectly();
        
        if (isSubscribed) {
          this.isProductSubscribed = true;
          _subscriptionCompleter?.complete();
          debugPrint("✅ Subscription found via direct check");
          callBack(true);
          return;
        }
        
        // If direct check fails, fall back to restore
        debugPrint("⚠️ Direct check returned false, trying restore purchase...");
      }
      
      // Fallback to restore purchase (works for both RevenueCat and old method)
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
      debugPrint("loading showed...");
      isLoading.value = true;
      EasyLoading.instance.userInteractions = false;
      EasyLoading.show(
        status: "",
        indicator: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.black,
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
          color: Colors.black,
          size: 50,
        ),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: false,
      );
    }
  }

  void _handlePurchaseResult(PurchaseStatus status, String message,
      {bool isProductSubscribed = false}) {
    debugPrint("=== _handlePurchaseResult Called ===");
    debugPrint("Status: $status");
    debugPrint("Message: $message");
    debugPrint("isProductSubscribed: $isProductSubscribed");
    debugPrint("isLoading.value: $isLoading.value");
    
    // Always dismiss loading first to prevent stuck loading state
    if (isLoading.value) {
      debugPrint("loading removed...");
      isLoading.value = false;
    }
    // Always dismiss EasyLoading to ensure it's closed (safety check for cancelled purchases)
    EasyLoading.dismiss();
    
    // Only navigate back if we're not just checking status
    // If status is restored and no subscription found, don't navigate (it's just a status check)
    if (status == PurchaseStatus.restored && !isProductSubscribed) {
      // This is just a status check, don't navigate
      debugPrint("Status check only - not navigating");
    } else if (status == PurchaseStatus.error || message.contains("cancelled") || message.contains("canceled")) {
      // On error or cancellation, navigate back to close the popup
      debugPrint("Purchase error/cancelled - navigating back");
      try {
        Get.back();
      } catch (e) {
        debugPrint("Cannot pop: $e");
      }
    } else if (status != PurchaseStatus.restored) {
      // This is an actual purchase flow success, navigate back
      debugPrint("Purchase successful - navigating back");
      try {
        Get.back();
      } catch (e) {
        debugPrint("Cannot pop: $e");
      }
    }

    switch (status) {
      case PurchaseStatus.error:
        if (message.contains("BillingResponse.itemAlreadyOwned") ||
            message.contains("BillingResponse.developerError")) {
          this.isProductSubscribed = true; // Item already owned means user is subscribed
          // Complete the completer when item is already owned
          _subscriptionCompleter?.complete();
          // Navigate to dashboard/home when item is already owned
          Get.offAllNamed(Routes.HOME);
        } else {
          // Complete the completer even for errors to prevent hanging
          _subscriptionCompleter?.complete();
          Get.snackbar(
            status == PurchaseStatus.error ? 'Error' : 'Success',
            "Payment Cancel",
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 10),
          );
        }
        break;
      case PurchaseStatus.purchased:
        debugPrint("Processing PurchaseStatus.purchased - navigating to HOME");
        this.isProductSubscribed = isProductSubscribed;
        
        // Extract product ID from message if available
        // Message format: "Purchase successful: com.app.buddy.basic" or "Purchase successful: com.app.buddy.pro"
        String? productId;
        if (message.contains("com.app.buddy.")) {
          productId = message.split("com.app.buddy.")[1].split(" ")[0];
          
          // Check if this is an upgrade (user previously had basic, now buying pro)
          final previousProductId = getStorageData.readString("subscribed_product_id");
          bool isUpgrade = previousProductId != null && 
                          previousProductId.contains("basic") && 
                          productId == "pro";
          
          getStorageData.saveString("subscribed_product_id", "com.app.buddy.$productId");
          
          // Send payment info to backend after successful purchase
          // Always use POST API (same for new purchases and upgrades)
          Future.delayed(const Duration(milliseconds: 500), () {
            if (isUpgrade && productId == "pro") {
              // This is an upgrade to Pro - use POST API
              debugPrint("🔄 Detected upgrade to Pro - calling POST API");
              PaymentApiService.updatePaymentInfoAfterUpgrade();
            } else {
              // This is a new purchase - use POST API
              debugPrint("💰 New purchase - calling POST API");
              PaymentApiService.sendPaymentInfoAfterPurchase("com.app.buddy.$productId");
            }
          });
        }
        
        // Complete the completer when purchase is successful
        _subscriptionCompleter?.complete();
        // Navigate to dashboard/home after successful purchase
        Get.offAllNamed(Routes.HOME);
        break;
      case PurchaseStatus.restored:
        this.isProductSubscribed = isProductSubscribed;
        
        // Extract product ID from message if available during restore
        if (message.contains("com.app.buddy.")) {
          final productId = message.split("com.app.buddy.")[1].split(" ")[0];
          getStorageData.saveString("subscribed_product_id", "com.app.buddy.$productId");
        } else if (isProductSubscribed && message.contains("Restore Purchase successful")) {
          // If restored but product ID not in message, try to get from purchase details
          // This is a fallback - ideally product ID should be in the message
        }
        
        // Complete the completer when restoration is processed
        _subscriptionCompleter?.complete();
        break;
      default:
        // Complete the completer for any other status to prevent hanging
        _subscriptionCompleter?.complete();
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
