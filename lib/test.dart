import 'dart:async';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:buddy/api_repository/loading.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/core/constants/imports.dart';

import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Loading();
  Utils.screenPortrait();
  runApp(MyApp());
}

/*

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeLight().theme,
                builder: EasyLoading.init(),
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes,
              ),
            ));
  }
}

*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _productIds = {'com.app.sparkd.premium.monthly'};
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    _initiatePurchaseStream();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _initiatePurchaseStream() {
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        print("listern $purchaseDetailsList");
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        print("Stream done");
      },
      onError: (error) {
        print("Stream error: $error");
      },
    );
  }

  Future<void> _subscribeProduct() async {
    clearTransactionsIos();
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;

    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        _showErrorDialog("In-App Purchase not Available");
        return;
      }

      if (Platform.isIOS) {
        var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(_productIds);
      if (productDetailResponse.error != null) {
        _showErrorDialog(
            "Product Query Error: ${productDetailResponse.error!.message}");
        return;
      } else if (productDetailResponse.productDetails.isEmpty) {
        _showErrorDialog("Product not Found");
        return;
      }

      final ProductDetails productDetails =
          productDetailResponse.productDetails[0];
      final PurchaseParam purchaseParam = Platform.isIOS
          ? PurchaseParam(productDetails: productDetails)
          : GooglePlayPurchaseParam(productDetails: productDetails);

      bool purchaseSuccess =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      if (purchaseSuccess) {
        print("Purchase initiated successfully");
      } else {
        _showErrorDialog("Failed to initiate purchase");
      }
    } catch (e) {
      _showErrorDialog("Payment Failed: ${e.toString()}");
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      print("Purchase Details: ${purchaseDetails.toString()}");
      print("Purchase status: ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Purchase status: Pending");
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _showErrorDialog("Purchase Error: ${purchaseDetails.error?.details}");
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _showSuccessDialog("Purchase successful!");
        } else {
          _handleInvalidPurchase(purchaseDetails);
          _showErrorDialog("Purchase validation failed");
        }
        if (purchaseDetails.pendingCompletePurchase) {
          try {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            print("Purchase completed successfully.");
          } catch (e) {
            print("Error completing purchase: ${e.toString()}");
          }
        }
      }
    }
  }

  Future<void> clearTransactionsIos() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      transactions.forEach((transaction) async {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Implement your purchase verification logic here
    return true; // For demo purposes, we assume the purchase is always valid
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // Handle invalid purchase
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In-App Purchase Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _subscribeProduct,
          child: Text('Subscribe'),
        ),
      ),
    );
  }
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
