// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:buddy_ai_wingman/api_repository/loading.dart';
import 'package:buddy_ai_wingman/api_repository/socket_service.dart';
import 'package:buddy_ai_wingman/core/constants/helper.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/core/theme/theme_light.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:buddy_ai_wingman/pages/settings/inapp_purchase_source.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await Firebase.initializeApp();
  Loading();
  Utils.screenPortrait();
//  Get.lazyPut<SocketService>(() => SocketService(), fenix: true);
  runApp(const MyApp());
}

PaymentPlanController getPaymentPlanController() {
  if (Get.isRegistered<PaymentPlanController>()) {
    debugPrint("Payment Dependencies already register");
    return Get.find<PaymentPlanController>();
  } else {
    debugPrint("Payment Dependencies going to register");
    Get.lazyPut<InAppPurchaseSource>(
      () => InAppPurchaseSourceImpl(),
      fenix: true,
    );

    Get.lazyPut<PaymentPlanController>(
      () => PaymentPlanController(
          inAppPurchaseSource: Get.find<InAppPurchaseSource>()),
      fenix: true,
    );
    return Get.find<PaymentPlanController>();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
