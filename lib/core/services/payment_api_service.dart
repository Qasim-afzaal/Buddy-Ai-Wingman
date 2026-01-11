import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/constants.dart';

/// Service to handle payment API calls
class PaymentApiService {
  /// Send payment information to backend
  /// 
  /// [pricingModel] - 'free', 'base', or 'pro'
  /// [amount] - Amount in cents (e.g., 999 for €9.99, 1499 for €14.99, 0 for free)
  /// [isFreeTrial] - true if user is on free trial, false otherwise
  static Future<void> sendPaymentInfo({
    required String pricingModel,
    required int amount,
    required bool isFreeTrial,
  }) async {
    try {
      debugPrint("💰 Sending payment info to backend:");
      debugPrint("   Pricing Model: $pricingModel");
      debugPrint("   Amount: $amount");
      debugPrint("   Is Free Trial: $isFreeTrial");

      final requestData = {
        "pricing_model": pricingModel,
        "amount": amount,
        "is_free_trial": isFreeTrial,
      };

      final token = getStorageData.readString(getStorageData.tokenKey);
      final response = await APIFunction().apiCall(
        apiName: "payments",
        withOutFormData: jsonEncode(requestData),
        token: token ?? "",
        isLoading: false, // Don't show loading indicator
      );

      debugPrint("✅ Payment info sent successfully");
      debugPrint("   Response: $response");
    } catch (e) {
      debugPrint("❌ Error sending payment info: $e");
      // Don't show error to user, just log it
    }
  }

  /// Determine payment info based on user's subscription status
  /// Returns a map with pricing_model, amount, and is_free_trial
  static Future<Map<String, dynamic>> determinePaymentInfo() async {
    try {
      // Check if user has subscription
      final storedProductId = getStorageData.readString("subscribed_product_id");
      bool hasSubscription = storedProductId != null && storedProductId.isNotEmpty;

      // If user has subscription, determine plan and amount
      if (hasSubscription) {
        String pricingModel;
        int amount;

        if (storedProductId!.contains("basic")) {
          pricingModel = "base";
          amount = 999; // €9.99 in cents
        } else if (storedProductId.contains("pro")) {
          pricingModel = "pro";
          amount = 1499; // €14.99 in cents
        } else {
          // Default to base if unknown
          pricingModel = "base";
          amount = 999;
        }

        return {
          "pricing_model": pricingModel,
          "amount": amount,
          "is_free_trial": false,
        };
      } else {
        // No subscription - user is on free trial
        return {
          "pricing_model": "free",
          "amount": 0,
          "is_free_trial": true,
        };
      }
    } catch (e) {
      debugPrint("Error determining payment info: $e");
      // Default to free trial on error
      return {
        "pricing_model": "free",
        "amount": 0,
        "is_free_trial": true,
      };
    }
  }

  /// Check if user is on free trial
  static bool isUserOnFreeTrial() {
    try {
      final loginData = getStorageData.readLoginData();
      final createdAtString = loginData.data?.createdAt;
      
      if (createdAtString != null && createdAtString.isNotEmpty) {
        final createdAt = DateTime.tryParse(createdAtString);
        
        if (createdAt != null) {
          final now = DateTime.now();
          final trialEndDate = createdAt.add(const Duration(days: 7));
          
          // Check if trial is still active
          if (now.isBefore(trialEndDate)) {
            // Also check if user has no subscription
            final storedProductId = getStorageData.readString("subscribed_product_id");
            bool hasSubscription = storedProductId != null && storedProductId.isNotEmpty;
            
            // User is on free trial only if trial is active AND no subscription
            return !hasSubscription;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint("Error checking free trial: $e");
      return false;
    }
  }

  /// Send payment info after login/signup
  /// Automatically determines if user is on free trial or has subscription
  static Future<void> sendPaymentInfoAfterAuth() async {
    try {
      // Check if user is on free trial
      bool isFreeTrial = isUserOnFreeTrial();
      
      if (isFreeTrial) {
        // User is on free trial, no subscription
        await sendPaymentInfo(
          pricingModel: "free",
          amount: 0,
          isFreeTrial: true,
        );
      } else {
        // User has subscription, get payment info
        final paymentInfo = await determinePaymentInfo();
        await sendPaymentInfo(
          pricingModel: paymentInfo["pricing_model"] as String,
          amount: paymentInfo["amount"] as int,
          isFreeTrial: false,
        );
      }
    } catch (e) {
      debugPrint("Error sending payment info after auth: $e");
    }
  }

  /// Send payment info after successful purchase
  /// [productId] - The purchased product ID (e.g., "com.app.buddy.basic" or "com.app.buddy.pro")
  static Future<void> sendPaymentInfoAfterPurchase(String productId) async {
    try {
      String pricingModel;
      int amount;

      if (productId.contains("basic")) {
        pricingModel = "base";
        amount = 999; // €9.99 in cents
      } else if (productId.contains("pro")) {
        pricingModel = "pro";
        amount = 1499; // €14.99 in cents
      } else {
        // Default to base if unknown
        pricingModel = "base";
        amount = 999;
      }

      await sendPaymentInfo(
        pricingModel: pricingModel,
        amount: amount,
        isFreeTrial: false,
      );
    } catch (e) {
      debugPrint("Error sending payment info after purchase: $e");
    }
  }

  /// Update payment info after successful upgrade to Pro
  /// This is called when user upgrades from Basic to Pro
  /// Uses POST API (same as new purchases)
  static Future<void> updatePaymentInfoAfterUpgrade() async {
    try {
      debugPrint("🔄 Updating payment info after upgrade to Pro (POST):");
      
      // Use POST API (same as new purchases)
      await sendPaymentInfo(
        pricingModel: "pro",
        amount: 1499, // €14.99 in cents
        isFreeTrial: false,
      );
    } catch (e) {
      debugPrint("Error updating payment info after upgrade: $e");
    }
  }
}
