import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:buddy_ai_wingman/api_repository/api_class.dart';

import 'package:buddy_ai_wingman/api_repository/api_function.dart';

import '../../core/constants/imports.dart';

abstract class InAppPurchaseSource {
  Future<void> subscribeProduct();

  void initiateStreamSubscription();

  void restorePurchase();

  void Function()? onLoading;
  void Function()? isAnimatedLoading;
  void Function(PurchaseStatus status, String message,
      {required bool isProductSubscribed})? onPurchaseResult;
}

class InAppPurchaseSourceImpl implements InAppPurchaseSource {
  Set<String> productIds = <String>{'com.app.sparkd.premium.monthly'};
  var isUserTryToSubscribeProduct = false;
  var isValidateProductSubscriptionStatus = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  Future<void> subscribeProduct() async {
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
        _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
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
        onPurchaseResult?.call(PurchaseStatus.restored, "No Subscription found",
            isProductSubscribed: false);
      }

      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      debugPrint("Stream subscription error: $error");
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
          onPurchaseResult?.call(PurchaseStatus.error,
              purchaseDetails.error?.message ?? 'Unknown error',
              isProductSubscribed: false);
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    bool valid = await verifyPurchase(purchaseDetails);
    if (valid) {
      if (isUserTryToSubscribeProduct) {
        onPurchaseResult?.call(PurchaseStatus.purchased,
            "Purchase successful: ${purchaseDetails.productID}",
            isProductSubscribed: true);
      }
    } else {
      handleInvalidPurchase(purchaseDetails);
    }
    isUserTryToSubscribeProduct = false;
  }

  bool checkStatus = false;
  Future<void> _restorePurchase(PurchaseDetails purchaseDetails) async {
    bool valid = await verifyPurchase(purchaseDetails);
    print("i am here in resytore");
    Map msg = {"name": " Recipt Verification Checking"};
    Constants.socket!.emit("logEvent", msg);
    if (valid) {
      var data = purchaseDetails.verificationData.localVerificationData;
      if (isValidateProductSubscriptionStatus) {
        isValidateProductSubscriptionStatus = false;
        if (Platform.isAndroid) {
          print("i am here in Androidrestore");
          var restoreData = jsonDecode(data) as Map<String, dynamic>;
          final isProductSubscribe = restoreData['autoRenewing'] == true;
          onPurchaseResult?.call(
              PurchaseStatus.restored, "Restore Purchase successful: Android",
              isProductSubscribed: isProductSubscribe);
          Map msg = {"name": " Recipt Done"};
          Constants.socket!.emit("logEvent", msg);
          debugPrint("Product is Active = $isProductSubscribe");
        } else if (Platform.isIOS) {
          Map chatmsg = {"name": "${HttpUtil.email} restore Hit"};
          Constants.socket!.emit("logEvent", chatmsg);
          final response = await InAppPurchase.instance
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
              .refreshPurchaseVerificationData();
          String receipt = response!.localVerificationData;
          print("this is receipt");
          Map rcp = {"name": " getting recipt"};
          Constants.socket!.emit("logEvent", rcp);
          Map msg = {"name": " Recipt Verification Checking"};
          Constants.socket!.emit("logEvent", msg);
          await validateIOSReceipt(receipt);

          bool isSubscribed = checkStatus;
          onPurchaseResult?.call(
              PurchaseStatus.restored, "Restore Purchase successful: IOS",
              isProductSubscribed: isSubscribed);
          debugPrint("Product is Active = $isSubscribed");
          Map restore = {
            "name": "${HttpUtil.email} roduct is Active = $isSubscribed"
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
    Map msg = {"name": "Payment Api"};
    Constants.socket!.emit("logEvent", msg);
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
        print("resspone$response");
        Map msg = {"name": "Payment Api Complete"};
        Constants.socket!.emit("logEvent", msg);
        checkStatus = response["data"]["subscriptionStatus"];
        print("resspone ssstauts$checkStatus");
        Map msgs = {"name": "Payment Api status$checkStatus"};
        Constants.socket!.emit("logEvent", msgs);
      } else {
        print(response['message']);
        // Helpers.snackbars.error(title: "Oops!", message: response["message"]);
      }
    } catch (error) {
      print("Error: $error");
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
  //       ..write(jsonEncode({'receipt-data': receipt, 'password': 'f04ad880f80c416e84f82110f01d0def', 'exclude-old-transactions': true}));

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
      Map msg = {"name": " Restoring"};
      Constants.socket!.emit("logEvent", msg);
      await _inAppPurchase.restorePurchases();
      Map restore = {"name": " Restore Complete ....."};
      Constants.socket!.emit("logEvent", restore);
      debugPrint("Subscription Check initiated");
      Map inapi = {"name": " in recipt api"};
      Constants.socket!.emit("logEvent", inapi);
      Map inapis = {"name": " check recipt status ::: false"};
      Constants.socket!.emit("logEvent", inapis);
    } catch (e) {
      if (e is SKError) {
        debugPrint("SKError code: '${e.code}', userInfo: '${e.userInfo}'");
        onPurchaseResult?.call(PurchaseStatus.restored, "No Subscription found",
            isProductSubscribed: false);
      } else {
        debugPrint("Failed to restore purchase: ${e.toString()}");
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
