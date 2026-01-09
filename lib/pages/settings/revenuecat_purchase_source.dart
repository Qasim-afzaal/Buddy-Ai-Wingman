import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/settings/inapp_purchase_source.dart';

class RevenueCatPurchaseSourceImpl implements InAppPurchaseSource {
  var isUserTryToSubscribeProduct = false;
  var isValidateProductSubscriptionStatus = false;
  bool _isListenerInitialized = false;

  @override
  Future<void> subscribeProduct(String productId) async {
    onLoading?.call();
    isUserTryToSubscribeProduct = true;

    try {
      // Purchase product directly without using offerings system
      // Get products directly from store
      List<StoreProduct> products = await Purchases.getProducts([productId]);
      
      if (products.isEmpty) {
        debugPrint("⚠️ RevenueCat: Product not found: $productId");
        debugPrint("💡 Make sure product $productId exists in App Store/Play Store");
        onPurchaseResult?.call(
          PurchaseStatus.error,
          "Product not found: $productId. Please check product configuration.",
          isProductSubscribed: false,
        );
        isUserTryToSubscribeProduct = false;
        return;
      }

      // Get the product
      StoreProduct product = products.first;
      debugPrint("✅ RevenueCat: Found product ${product.identifier} - ${product.title}");

      // Make the purchase directly using the product (without offerings)
      // purchaseStoreProduct returns CustomerInfo directly
      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(product);
      
      // Check if purchase was successful
      if (customerInfo.entitlements.active.isNotEmpty) {
        // User has active entitlements
        String? activeEntitlementId = customerInfo.entitlements.active.keys.first;
        EntitlementInfo entitlementInfo = customerInfo.entitlements.active[activeEntitlementId]!;
        debugPrint("✅ Purchase successful. Active entitlement: $activeEntitlementId");
        debugPrint("✅ Product ID: ${entitlementInfo.productIdentifier}");
        
        // Store the product ID
        getStorageData.saveString("subscribed_product_id", productId);
        
        onPurchaseResult?.call(
          PurchaseStatus.purchased,
          "Purchase successful: $productId",
          isProductSubscribed: true,
        );
      } else {
        // Check if product was purchased but no entitlements (might need to attach entitlements in dashboard)
        debugPrint("⚠️ Purchase completed but no active entitlements");
        debugPrint("💡 Make sure product $productId is attached to an entitlement in RevenueCat dashboard");
        
        // Still consider it successful if purchase went through
        // User might have entitlements configured differently
        getStorageData.saveString("subscribed_product_id", productId);
        
        onPurchaseResult?.call(
          PurchaseStatus.purchased,
          "Purchase successful: $productId",
          isProductSubscribed: true,
        );
      }
    } on PlatformException catch (e) {
      String errorMessage = "Payment Failed";
      String errorCode = e.code.toString().toLowerCase();
      
      // Handle RevenueCat error codes (checking string patterns)
      if (errorCode.contains('cancelled') || errorCode.contains('canceled') || 
          errorCode == 'purchasecancellederror') {
        errorMessage = "Purchase cancelled by user";
        debugPrint("RevenueCat purchase cancelled by user");
      } else if (errorCode.contains('notallowed') || errorCode == 'purchasenotallowederror') {
        errorMessage = "Purchase not allowed";
      } else if (errorCode.contains('invalid') || errorCode == 'purchaseinvaliderror') {
        errorMessage = "Invalid purchase";
      } else if (errorCode.contains('notavailable') || errorCode == 'productnotavailableforpurchaseerror') {
        errorMessage = "Product not available";
      } else if (errorCode.contains('network') || errorCode == 'networkerror') {
        errorMessage = "Network error. Please check your connection";
      }
      
      debugPrint("RevenueCat purchase error: ${e.code} - ${e.message}");
      
      // Handle specific error code 23 (no products configured)
      if (e.code == '23' || e.message?.contains('no products registered') == true) {
        debugPrint("⚠️ RevenueCat Error 23: Products not configured in dashboard");
        debugPrint("💡 Required Product IDs: com.app.buddy.basic, com.app.buddy.pro");
        debugPrint("💡 See REVENUECAT_PRODUCTS_SETUP.md for setup instructions");
        errorMessage = "Subscription products not configured. Please contact support.";
      }
      
      // Reset the purchase flag on error
      isUserTryToSubscribeProduct = false;
      onPurchaseResult?.call(
        PurchaseStatus.error,
        errorMessage,
        isProductSubscribed: false,
      );
    } catch (e) {
      debugPrint("RevenueCat purchase exception: $e");
      // Reset the purchase flag on exception
      isUserTryToSubscribeProduct = false;
      // Check if it's a cancellation error
      if (e.toString().contains('cancelled') || e.toString().contains('canceled')) {
        onPurchaseResult?.call(
          PurchaseStatus.error,
          "Purchase cancelled by user",
          isProductSubscribed: false,
        );
      } else {
        onPurchaseResult?.call(
          PurchaseStatus.error,
          "Payment Failed: ${e.toString()}",
          isProductSubscribed: false,
        );
      }
    } finally {
      isUserTryToSubscribeProduct = false;
    }
  }

  @override
  void initiateStreamSubscription() {
    if (_isListenerInitialized) {
      debugPrint("RevenueCat subscription is already initialized.");
      return;
    }

    // Listen to customer info updates
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      debugPrint("Customer info updated");
      debugPrint("Active Entitlements: ${customerInfo.entitlements.active.length}");
      debugPrint("Active Subscriptions: ${customerInfo.activeSubscriptions.length}");
      
      // Check both entitlements AND active subscriptions
      bool hasActiveEntitlements = customerInfo.entitlements.active.isNotEmpty;
      bool hasActiveSubscriptions = customerInfo.activeSubscriptions.isNotEmpty;
      bool isSubscribed = hasActiveEntitlements || hasActiveSubscriptions;
      
      if (isValidateProductSubscriptionStatus) {
        isValidateProductSubscriptionStatus = false;
        
        // Try to get product ID
        String? productId;
        if (hasActiveEntitlements) {
          String? activeEntitlementId = customerInfo.entitlements.active.keys.first;
          EntitlementInfo entitlementInfo = customerInfo.entitlements.active[activeEntitlementId]!;
          productId = entitlementInfo.productIdentifier;
        } else if (hasActiveSubscriptions) {
          productId = customerInfo.activeSubscriptions.first;
        }
        
        if (productId != null && productId.isNotEmpty) {
          getStorageData.saveString("subscribed_product_id", productId);
        }
        
        onPurchaseResult?.call(
          PurchaseStatus.restored,
          isSubscribed 
            ? "Restore Purchase successful" 
            : "No Subscription found",
          isProductSubscribed: isSubscribed,
        );
      } else if (isUserTryToSubscribeProduct && isSubscribed) {
        // Handle purchase completion
        if (hasActiveEntitlements) {
          String? activeEntitlementId = customerInfo.entitlements.active.keys.first;
          debugPrint("Purchase completed via listener. Active entitlement: $activeEntitlementId");
        } else if (hasActiveSubscriptions) {
          String? activeSubscriptionId = customerInfo.activeSubscriptions.first;
          debugPrint("Purchase completed via listener. Active subscription: $activeSubscriptionId");
        }
      }
    });
    
    _isListenerInitialized = true;
  }

  @override
  void restorePurchase() async {
    try {
      isAnimatedLoading?.call();
      isValidateProductSubscriptionStatus = true;
      debugPrint("RevenueCat restore purchase initiated");

      // Get customer info (this includes both entitlements and active subscriptions)
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      // Log customer info for debugging
      debugPrint("=== RevenueCat Customer Info ===");
      debugPrint("Active Entitlements: ${customerInfo.entitlements.active.length}");
      debugPrint("Active Subscriptions: ${customerInfo.activeSubscriptions.length}");
      debugPrint("All Purchased Product IDs: ${customerInfo.allPurchasedProductIdentifiers}");
      
      // Check both entitlements AND active subscriptions
      bool hasActiveEntitlements = customerInfo.entitlements.active.isNotEmpty;
      bool hasActiveSubscriptions = customerInfo.activeSubscriptions.isNotEmpty;
      bool hasPurchasedProducts = customerInfo.allPurchasedProductIdentifiers.isNotEmpty;
      
      // User is subscribed if they have active entitlements OR active subscriptions
      bool isSubscribed = hasActiveEntitlements || hasActiveSubscriptions;
      
      if (isSubscribed) {
        String? productId;
        
        // Try to get product ID from entitlement first
        if (hasActiveEntitlements) {
          String? activeEntitlementId = customerInfo.entitlements.active.keys.first;
          EntitlementInfo entitlementInfo = customerInfo.entitlements.active[activeEntitlementId]!;
          productId = entitlementInfo.productIdentifier;
          debugPrint("✅ Found subscription via entitlement: $activeEntitlementId");
          debugPrint("✅ Product ID from entitlement: $productId");
        }
        
        // If no product ID from entitlement, try to get from active subscriptions
        if ((productId == null || productId.isEmpty) && hasActiveSubscriptions) {
          // Get the first active subscription product ID (activeSubscriptions is a List)
          productId = customerInfo.activeSubscriptions.first;
          debugPrint("✅ Found subscription via activeSubscriptions: $productId");
        }
        
        // If still no product ID, check all purchased products
        if ((productId == null || productId.isEmpty) && hasPurchasedProducts) {
          // Check if any purchased product matches our product IDs
          for (String purchasedId in customerInfo.allPurchasedProductIdentifiers) {
            if (purchasedId.contains("com.app.buddy.basic") || 
                purchasedId.contains("com.app.buddy.pro")) {
              productId = purchasedId;
              debugPrint("✅ Found subscription via allPurchasedProductIdentifiers: $productId");
              break;
            }
          }
        }
        
        // Store the product ID if found
        if (productId != null && productId.isNotEmpty) {
          getStorageData.saveString("subscribed_product_id", productId);
          debugPrint("✅ Stored product ID: $productId");
        } else {
          // Fallback: check stored product ID from previous purchase
          final storedProductId = getStorageData.readString("subscribed_product_id");
          if (storedProductId != null && storedProductId.isNotEmpty) {
            productId = storedProductId;
            debugPrint("✅ Using stored product ID: $productId");
          }
        }
        
        debugPrint("✅ Restore successful - User has active subscription");
        isValidateProductSubscriptionStatus = false;
        onPurchaseResult?.call(
          PurchaseStatus.restored,
          "Restore Purchase successful",
          isProductSubscribed: true,
        );
      } else {
        debugPrint("⚠️ No active subscriptions found");
        debugPrint("💡 Active Entitlements: $hasActiveEntitlements");
        debugPrint("💡 Active Subscriptions: $hasActiveSubscriptions");
        debugPrint("💡 Purchased Products: $hasPurchasedProducts");
        debugPrint("💡 Make sure products are attached to entitlements in RevenueCat dashboard");
        
        isValidateProductSubscriptionStatus = false;
        onPurchaseResult?.call(
          PurchaseStatus.restored,
          "No Subscription found",
          isProductSubscribed: false,
        );
      }
    } catch (e) {
      debugPrint("❌ Failed to restore purchase: ${e.toString()}");
      isValidateProductSubscriptionStatus = false;
      onPurchaseResult?.call(
        PurchaseStatus.error,
        "Restore failed: ${e.toString()}",
        isProductSubscribed: false,
      );
    }
  }

  @override
  void Function()? onLoading;

  @override
  void Function(PurchaseStatus status, String message,
      {required bool isProductSubscribed})? onPurchaseResult;

  @override
  void Function()? isAnimatedLoading;

  /// Directly check subscription status without restoring
  /// This is faster and doesn't require restore purchase flow
  Future<bool> checkSubscriptionStatusDirectly() async {
    try {
      debugPrint("🔍 Checking subscription status directly...");
      
      // Get customer info directly (faster than restore)
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      // Log for debugging
      debugPrint("=== Direct Subscription Check ===");
      debugPrint("Active Entitlements: ${customerInfo.entitlements.active.length}");
      debugPrint("Active Subscriptions: ${customerInfo.activeSubscriptions.length}");
      debugPrint("All Purchased Products: ${customerInfo.allPurchasedProductIdentifiers}");
      
      // Check both entitlements AND active subscriptions
      bool hasActiveEntitlements = customerInfo.entitlements.active.isNotEmpty;
      bool hasActiveSubscriptions = customerInfo.activeSubscriptions.isNotEmpty;
      bool isSubscribed = hasActiveEntitlements || hasActiveSubscriptions;
      
      if (isSubscribed) {
        // Try to get and store product ID
        String? productId;
        
        if (hasActiveEntitlements) {
          String? activeEntitlementId = customerInfo.entitlements.active.keys.first;
          EntitlementInfo entitlementInfo = customerInfo.entitlements.active[activeEntitlementId]!;
          productId = entitlementInfo.productIdentifier;
        } else if (hasActiveSubscriptions) {
          productId = customerInfo.activeSubscriptions.first;
        }
        
        // Check purchased products as fallback
        if ((productId == null || productId.isEmpty) && customerInfo.allPurchasedProductIdentifiers.isNotEmpty) {
          for (String purchasedId in customerInfo.allPurchasedProductIdentifiers) {
            if (purchasedId.contains("com.app.buddy.basic") || 
                purchasedId.contains("com.app.buddy.pro")) {
              productId = purchasedId;
              break;
            }
          }
        }
        
        if (productId != null && productId.isNotEmpty) {
          getStorageData.saveString("subscribed_product_id", productId);
          debugPrint("✅ Subscription active - Product ID: $productId");
        } else {
          debugPrint("✅ Subscription active (product ID not found, using stored)");
        }
        
        return true;
      } else {
        debugPrint("❌ No active subscription found");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error checking subscription status: $e");
      return false;
    }
  }

  void dispose() {
    // RevenueCat listeners are managed internally, no need to cancel
    _isListenerInitialized = false;
  }
}
