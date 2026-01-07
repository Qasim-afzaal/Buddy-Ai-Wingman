import 'dart:io';
import 'package:buddy/widgets/confirmation_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/services/onesignal_service.dart';
import 'package:buddy/main.dart';
import 'package:buddy/pages/settings/revenuecat_purchase_source.dart';

import '../../models/error_response.dart';

class ProfileBeforePaymentController extends GetxController {
  var isSubscribed = false.obs;
  var subscriptionPlan = "".obs; // "Basic" or "Pro"
  var trialDaysRemaining = 0.obs;
  var isTrialActive = false.obs;
  var isLoadingSubscription = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkSubscriptionStatus();
    calculateTrialDays();
  }

  Future<void> checkSubscriptionStatus() async {
    isLoadingSubscription.value = true;
    try {
      final paymentController = getPaymentPlanController();
      
      // Check if product ID is stored locally
      final storedProductId = getStorageData.readString("subscribed_product_id");
      
      // Pass loadingRequired: false to prevent navigation and loading dialog
      await paymentController.isUserSubscribedToProduct((isSubscribed) {
        this.isSubscribed.value = isSubscribed;
        
        // Determine which plan is subscribed
        if (isSubscribed) {
          // Check stored product ID or default to "Active"
          if (storedProductId != null) {
            if (storedProductId.contains("basic")) {
              subscriptionPlan.value = "Basic";
            } else if (storedProductId.contains("pro")) {
              subscriptionPlan.value = "Pro";
            } else {
              subscriptionPlan.value = "Active";
            }
          } else {
            subscriptionPlan.value = "Active";
          }
          
          // Update OneSignal tags - user is subscribed
          OneSignalService.instance.removeTrialTags();
        } else {
          subscriptionPlan.value = "";
          // Recalculate trial days when not subscribed
          calculateTrialDays();
        }
        isLoadingSubscription.value = false;
        update();
      }, loadingRequired: false);
    } catch (e) {
      isLoadingSubscription.value = false;
      debugPrint("Error checking subscription: $e");
    }
  }

  void calculateTrialDays() {
    try {
      final loginData = getStorageData.readLoginData();
      final createdAtString = loginData.data?.createdAt;
      
      if (createdAtString != null && createdAtString.isNotEmpty) {
        final createdAt = DateTime.tryParse(createdAtString);
        
        if (createdAt != null) {
          final now = DateTime.now();
          final trialEndDate = createdAt.add(const Duration(days: 7));
          
          if (now.isBefore(trialEndDate)) {
            // Trial is still active
            isTrialActive.value = true;
            final difference = trialEndDate.difference(now);
            trialDaysRemaining.value = difference.inDays;
            
            // Update OneSignal tags for trial tracking
            OneSignalService.instance.setTrialEndDate(trialEndDate);
          } else {
            // Trial has expired
            isTrialActive.value = false;
            trialDaysRemaining.value = 0;
          }
        }
      }
      update();
    } catch (e) {
      debugPrint("Error calculating trial days: $e");
    }
  }

  Future<void> deleteAccount() async {
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
   void upgradeToPro() async {
    try {
      debugPrint("🔄 Starting upgrade from Basic to Pro...");
      
      // Get payment controller
      final paymentController = getPaymentPlanController();
      
      // Check if already on Pro
      if (subscriptionPlan.value == "Pro") {
        Get.snackbar(
          'Already Pro',
          'You already have the Pro subscription',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Show confirmation dialog
      Get.bottomSheet(
        ConfirmationWidget(
          title: "Upgrade to Pro",
          description: "Upgrade your subscription to Pro for €14,99/month. "
              "You'll only pay the prorated difference for the remaining time in your current subscription. "
              "Your Basic subscription will be replaced with Pro immediately.",
          onConfirmation: () {
            // Pro product ID
            const proProductId = "com.app.buddy.pro";
            
            // Call the same subscribeProduct method
            // Apple/Google will automatically handle the upgrade and proration
            // Note: onSubscriptionPressed is void, so we just call it
            paymentController.onSubscriptionPressed(proProductId);
            
            // Refresh subscription status after upgrade
            // The payment controller's onPurchaseResult callback will handle status updates
            // We also refresh after a delay to ensure status is updated
            Future.delayed(const Duration(seconds: 3), () {
              checkSubscriptionStatus();
            });
          },
        ),
      );
    } catch (e) {
      debugPrint("Error upgrading to Pro: $e");
      Get.snackbar(
        'Error',
        'Failed to upgrade subscription. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
