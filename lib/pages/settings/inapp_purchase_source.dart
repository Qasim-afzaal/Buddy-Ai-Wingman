import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:buddy/api_repository/api_class.dart';

import 'package:buddy/api_repository/api_function.dart';

import '../../core/constants/imports.dart';

abstract class InAppPurchaseSource {
  Future<void> subscribeProduct(String productId);

  void initiateStreamSubscription();

  void restorePurchase();

  void Function()? onLoading;
  void Function()? isAnimatedLoading;
  void Function(PurchaseStatus status, String message,
      {required bool isProductSubscribed})? onPurchaseResult;
}

class InAppPurchaseSourceImpl implements InAppPurchaseSource {

  var isUserTryToSubscribeProduct = false;
  var isValidateProductSubscriptionStatus = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  Future<void> subscribeProduct(String productId) async {
    Set<String> productIds = <String>{
      productId,
    };

    onLoading?.call();
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        onPurchaseResult?.call(
            PurchaseStatus.error, "In-App Purchase not available",
            isProductSubscribed: false);
        return Future.error("In-App Purchase not available");
      }

      if (Platform.isIOS) {
        var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      await checkPendingTransactions(); // Ensure no pending transactions before proceeding

      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(productIds);

      debugPrint("Response of Products :: ${productDetailResponse.productDetails}");

      if (productDetailResponse.error != null) {
        onPurchaseResult?.call(PurchaseStatus.error, "Product Query Error",
            isProductSubscribed: false);
        return Future.error("Product Query Error");
      } else if (productDetailResponse.productDetails.isEmpty) {
        onPurchaseResult?.call(PurchaseStatus.error, "Product not Found",
            isProductSubscribed: false);
        return Future.error("Product not Found");
      } else {
        List<ProductDetails> products = productDetailResponse.productDetails;
        final ProductDetails productDetails = products[0];
        final PurchaseParam purchaseParam = Platform.isIOS
            ? PurchaseParam(productDetails: productDetails)
            : GooglePlayPurchaseParam(productDetails: productDetails);
        isUserTryToSubscribeProduct = true;
        debugPrint("Set isUserTryToSubscribeProduct = true before buyConsumable");
        // Note: buyConsumable may throw exceptions asynchronously, so we handle them in the stream listener
        // The stream listener will handle PurchaseStatus.canceled and PurchaseStatus.error cases
        _inAppPurchase.buyConsumable(purchaseParam: purchaseParam).catchError((error) {
          // Catch any immediate errors
          debugPrint("Error during buyConsumable: $error");
          isUserTryToSubscribeProduct = false;
          // Check if it's a cancellation error
          if (error.toString().contains('cancelled') || error.toString().contains('canceled')) {
            onPurchaseResult?.call(PurchaseStatus.error, "Purchase cancelled by user",
                isProductSubscribed: false);
          } else {
            onPurchaseResult?.call(PurchaseStatus.error, "Payment Failed: ${error.toString()}",
                isProductSubscribed: false);
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      isUserTryToSubscribeProduct = false;
      onPurchaseResult?.call(PurchaseStatus.error, "Payment Failed",
          isProductSubscribed: false);
      return Future.error("Payment Failed");
    }
  }

  @override
  void initiateStreamSubscription() {
    if (_subscription != null) {
      debugPrint("Subscription is already initialized.");
      return;
    }
    Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      if (purchaseDetailsList.isEmpty) {
        if (isValidateProductSubscriptionStatus) {
          debugPrint("No purchases found in stream - calling callback with false");
          isValidateProductSubscriptionStatus = false;
          onPurchaseResult?.call(PurchaseStatus.restored, "No Subscription found",
              isProductSubscribed: false);
        }
      }

      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      debugPrint("Stream subscription error: $error");
      if (isValidateProductSubscriptionStatus) {
        isValidateProductSubscriptionStatus = false;
        onPurchaseResult?.call(PurchaseStatus.error, "Stream error: $error",
            isProductSubscribed: false);
      }
    });
  }

  Future<void> checkPendingTransactions() async {
    try {
      if (Platform.isIOS) {
        var transactions = await SKPaymentQueueWrapper().transactions();
        for (var skPaymentTransactionWrapper in transactions) {
          if (skPaymentTransactionWrapper.transactionState ==
                  SKPaymentTransactionStateWrapper.purchased ||
              skPaymentTransactionWrapper.transactionState ==
                  SKPaymentTransactionStateWrapper.failed) {
            SKPaymentQueueWrapper()
                .finishTransaction(skPaymentTransactionWrapper);
          }
        }
      }
    } catch (e) {
      debugPrint("Failed to check or finish pending transactions: $e");
    }
  }

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint("Purchase pending: ${purchaseDetails.productID}");
          break;
        case PurchaseStatus.error:
          debugPrint(
              "Purchase Error: ${purchaseDetails.error?.message ?? 'Unknown error'}");
          // Reset the purchase flag on error
          isUserTryToSubscribeProduct = false;
          onPurchaseResult?.call(PurchaseStatus.error,
              purchaseDetails.error?.message ?? 'Unknown error',
              isProductSubscribed: false);
          break;
        case PurchaseStatus.purchased:
          handlePurchase(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          _restorePurchase(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          debugPrint("Purchase cancelled by user: ${purchaseDetails.productID}");
          // Reset the purchase flag
          isUserTryToSubscribeProduct = false;
          // Dismiss loading and notify
          onPurchaseResult?.call(PurchaseStatus.error,
              "Purchase cancelled by user",
              isProductSubscribed: false);
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    debugPrint("=== Purchase Details ===");
    debugPrint("Product ID: ${purchaseDetails.productID}");
    debugPrint("Status: ${purchaseDetails.status}");
    debugPrint("isUserTryToSubscribeProduct: $isUserTryToSubscribeProduct");
    
    bool valid = await verifyPurchase(purchaseDetails);
    debugPrint("Purchase validation result: $valid");
    
    if (valid) {
      if (isUserTryToSubscribeProduct) {
        debugPrint("Calling onPurchaseResult with PurchaseStatus.purchased");
        onPurchaseResult?.call(PurchaseStatus.purchased,
            "Purchase successful: ${purchaseDetails.productID}",
            isProductSubscribed: true);
      } else {
        debugPrint("Purchase valid but isUserTryToSubscribeProduct is false - not calling callback");
      }
    } else {
      debugPrint("Purchase validation failed - calling handleInvalidPurchase");
      handleInvalidPurchase(purchaseDetails);
    }
    debugPrint("Resetting isUserTryToSubscribeProduct to false in handlePurchase");
    isUserTryToSubscribeProduct = false;
  }

  bool checkStatus = false;
  Future<void> _restorePurchase(PurchaseDetails purchaseDetails) async {
    debugPrint("i am here in restore");
    debugPrint("isUserTryToSubscribeProduct: $isUserTryToSubscribeProduct");
    debugPrint("isValidateProductSubscriptionStatus: $isValidateProductSubscriptionStatus");
    
    bool valid = await verifyPurchase(purchaseDetails);
    debugPrint("i am here in restore - validation result: $valid");

    if (valid) {
      // Check if this is a new purchase (not a restore)
      if (isUserTryToSubscribeProduct) {
        debugPrint("This is a new purchase being processed as restore - calling handlePurchase");
        debugPrint("Resetting isUserTryToSubscribeProduct to false in _restorePurchase");
        isUserTryToSubscribeProduct = false;
        onPurchaseResult?.call(PurchaseStatus.purchased,
            "Purchase successful: ${purchaseDetails.productID}",
            isProductSubscribed: true);
        return;
      }
      
      var data = purchaseDetails.verificationData.localVerificationData;
      if (isValidateProductSubscriptionStatus) {
        isValidateProductSubscriptionStatus = false;
        if (Platform.isAndroid) {
          debugPrint("i am here in Android Restore");
          var restoreData = jsonDecode(data) as Map<String, dynamic>;
          final isProductSubscribe = restoreData['autoRenewing'] == true;
          onPurchaseResult?.call(
              PurchaseStatus.restored, "Restore Purchase successful: Android",
              isProductSubscribed: isProductSubscribe);
          Map msg = {"name": " Receipt Done"};
          Constants.socket!.emit("logEvent", msg);
          debugPrint("Product is Active = $isProductSubscribe");
        } else if (Platform.isIOS) {
        
          final response = await InAppPurchase.instance
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
              .refreshPurchaseVerificationData();
          String receipt = response!.localVerificationData;
          debugPrint("this is receipt");

          await validateIOSReceipt(receipt);

          bool isSubscribed = checkStatus;
          onPurchaseResult?.call(
              PurchaseStatus.restored, "Restore Purchase successful: IOS",
              isProductSubscribed: isSubscribed);
          debugPrint("Product is Active = $isSubscribed");
          Map restore = {
            "name": "${HttpUtil.email} product is Active = $isSubscribed"
          };
          Constants.socket!.emit("logEvent", restore);
        }
      }
    } else {
      handleInvalidPurchase(purchaseDetails);
    }
  }

  Future<void> validateIOSReceipt(String receipt) async {
    Map<String, dynamic> requestBody = {
      "receipt": receipt,
    };

    try {
      final response = await APIFunction().sendPostRequest(
        requestBody,
        "auth/",
        "validate",
        null,
      );
      Map msg = {"name": "Payment Api HITTING"};
      Constants.socket!.emit("logEvent", msg);
      if (response["success"] == true) {
        debugPrint("Response $response");
  
        checkStatus = response["data"]["subscriptionStatus"];
        debugPrint("Response status $checkStatus");
     
      } else {
        debugPrint(response['message']);
        // Helpers.snackbars.error(title: "Oops!", message: response["message"]);
      }
    } catch (error) {
      debugPrint("Error: $error");
    }
  }
  
  
  // Future<bool> validateIOSReceipt(String receipt) async {
  //   print("this is recp $receipt");
  //   const appStoreURL =
  //   // "https://buy.itunes.apple.com/verifyReceipt";
  //   'https://sandbox.itunes.apple.com/verifyReceipt';
  //   try {
  //     final response = await HttpClient().postUrl(Uri.parse(appStoreURL))
  //       ..headers.contentType = ContentType.json
  //       ..write(jsonEncode({'receipt-data': receipt, 'password': '394c3ad0e6a947698f4bba2134207535', 'exclude-old-transactions': true}));

  //     final receiptResponse = await response.close();
  //     final responseBody = await receiptResponse.transform(utf8.decoder).join();
  //     final receiptData = jsonDecode(responseBody);
  //     return receiptData['status'] == 0 && isReceiptSubscribed(receiptData);
  //   } catch (e) {
  //     debugPrint("Receipt validation failed: $e");
  //     return false;
  //   }
  // }

  // bool isReceiptSubscribed(Map<String, dynamic> receiptData) {
  //   debugPrint("Checking product subscription status ....");
  //   if (receiptData['latest_receipt_info'] != null) {
  //     List<dynamic> latestReceiptInfo = receiptData['latest_receipt_info'];
  //     for (var receipt in latestReceiptInfo) {
  //       if (receipt['expires_date_ms'] != null) {
  //         final expirationDate = DateTime.fromMillisecondsSinceEpoch(int.parse(receipt['expires_date_ms']));
  //         if (expirationDate.isAfter(DateTime.now())) {
  //           debugPrint("Subscription is Active");
  //           return true;
  //         }
  //       }
  //     }
  //   }
  //   return false;
  // }

  Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
      // debugPrint("Purchase completion successful for: ${purchaseDetails.verificationData.localVerificationData}");
    } catch (e) {
      debugPrint("Failed to complete purchase: ${e.toString()}");
    }
  }

  void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    debugPrint("Invalid purchase detected: ${purchaseDetails.productID}");
    onPurchaseResult?.call(PurchaseStatus.error,
        "Invalid purchase detected: ${purchaseDetails.productID}",
        isProductSubscribed: false);
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      return Future.value(true);
    } catch (e) {
      debugPrint("Verification failed: ${e.toString()}");
      return Future.value(false);
    }
  }

  @override
  void Function()? onLoading;

  @override
  void Function(PurchaseStatus status, String message,
      {required bool isProductSubscribed})? onPurchaseResult;

  @override
  void restorePurchase() async {
    try {
      isAnimatedLoading?.call();
      isValidateProductSubscriptionStatus = true;
      debugPrint("Subscription Check initiated");
     
      await _inAppPurchase.restorePurchases();
      
      // Add a timeout to handle cases where no purchases are found
      // This ensures the callback is always called
      Timer(const Duration(seconds: 3), () {
        if (isValidateProductSubscriptionStatus) {
          debugPrint("No purchases found during restore - calling callback with false");
          isValidateProductSubscriptionStatus = false;
          onPurchaseResult?.call(PurchaseStatus.restored, "No Subscription found",
              isProductSubscribed: false);
        }
      });

    } catch (e) {
      debugPrint("Failed to restore purchase: ${e.toString()}");
      isValidateProductSubscriptionStatus = false;
      if (e is SKError) {
        debugPrint("SKError code: '${e.code}', userInfo: '${e.userInfo}'");
        onPurchaseResult?.call(PurchaseStatus.restored, "No Subscription found",
            isProductSubscribed: false);
      } else {
        onPurchaseResult?.call(PurchaseStatus.error, "Restore failed: ${e.toString()}",
            isProductSubscribed: false);
      }
    }
  }

  @override
  void Function()? isAnimatedLoading;
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
