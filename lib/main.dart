// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

import 'dart:convert';
import 'package:buddy/api_repository/loading.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/core/theme/theme_light.dart';
import 'package:buddy/core/services/notification_service.dart';
import 'package:buddy/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:buddy/pages/settings/inapp_purchase_source.dart';
import 'package:buddy/pages/settings/revenuecat_purchase_source.dart';
import 'package:buddy/routes/app_pages.dart';
import 'package:buddy/bloc/auth/auth_bloc.dart';
import 'package:buddy/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint("❌ Error initializing GetStorage: $e");
    // Continue execution as GetStorage might still work
  }
  
  // Load environment variables from .env file
  try {
    await AppConfig.load();
  } catch (e) {
    debugPrint("❌ Error loading AppConfig: $e");
    // Continue execution but app might not work properly without config
  }

  // Initialize RevenueCat with platform-specific API keys
  try {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
    
    // Use platform-specific API keys from environment variables
    String revenueCatApiKey;
    if (Platform.isIOS) {
      revenueCatApiKey = AppConfig.revenueCatAppleApiKey;
    } else if (Platform.isAndroid) {
      revenueCatApiKey = AppConfig.revenueCatGoogleApiKey;
    } else {
      revenueCatApiKey = AppConfig.revenueCatGoogleApiKey; // Default to Android
    }
    
    await Purchases.configure(
      PurchasesConfiguration(revenueCatApiKey)
        ..appUserID = null // RevenueCat will generate an anonymous ID
    );
    debugPrint("✅ RevenueCat initialized successfully with key: ${Platform.isIOS ? 'iOS' : 'Android'}");
  } catch (e) {
    debugPrint("❌ Error initializing RevenueCat: $e");
  }

  // Initialize Notification Service (both push and local notifications)
  try {
    await NotificationService.instance.initialize(
      iosOneSignalAppId: '0f62dbc7-12e5-4c48-9a7f-a66410067968', // OneSignal App ID
      androidOneSignalAppId: '0f62dbc7-12e5-4c48-9a7f-a66410067968', // OneSignal App ID
    );
  } catch (e) {
    debugPrint("❌ Error initializing NotificationService: $e");
    // Continue execution as notifications are not critical for app startup
  }

  // Get OneSignal Player ID after initialization (runs asynchronously)
  // Note: Player ID may take a few seconds to be available, especially if permissions are not granted yet
  _getPlayerIdAsync();

  // await Firebase.initializeApp();
  Loading();
  Utils.screenPortrait();
//  Get.lazyPut<SocketService>(() => SocketService(), fenix: true);
  runApp(const MyApp());
}

/// Get Player ID asynchronously (runs in background, doesn't block app startup)
Future<void> _getPlayerIdAsync() async {
  try {
    // Wait for OneSignal to fully initialize and request permissions
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Get Player ID (waits for it if not ready, with multiple retries)
    String? playerId;
    int attempts = 0;
    const maxAttempts = 5;
    
    while (attempts < maxAttempts && (playerId == null || playerId.isEmpty)) {
      playerId = await NotificationService.instance.getPlayerId();
      
      if (playerId == null || playerId.isEmpty) {
        attempts++;
        debugPrint('⏳ Waiting for Player ID... (attempt $attempts/$maxAttempts)');
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    }
    
    if (playerId != null && playerId.isNotEmpty) {
      debugPrint('=== ✅ OneSignal Player ID Retrieved ===');
      debugPrint('Player ID: $playerId');
      debugPrint('========================================');
      
      // If user is logged in, send Player ID to backend
      final userId = getStorageData.getUserId();
      if (userId != null) {
        debugPrint('User is logged in. Sending Player ID to backend...');
        // await _sendPlayerIdToBackend(userId, playerId);
      }
    } else {
      debugPrint('⚠️ Player ID not available after $maxAttempts attempts.');
      debugPrint('💡 The Player ID will be logged automatically when it becomes available.');
      debugPrint('💡 Make sure notification permissions are granted in device settings.');
      debugPrint('💡 Check console for "OneSignal Player ID updated" message.');
    }
  } catch (e) {
    debugPrint('Error getting Player ID: $e');
  }
}

PaymentPlanController getPaymentPlanController() {
  if (Get.isRegistered<PaymentPlanController>()) {
    debugPrint("Payment Dependencies already register");
    return Get.find<PaymentPlanController>();
  } else {
    debugPrint("Payment Dependencies going to register");
    // Using RevenueCat for in-app purchases (old InAppPurchaseSourceImpl code is kept intact)
    Get.lazyPut<InAppPurchaseSource>(
      () => RevenueCatPurchaseSourceImpl(), // RevenueCat implementation
      // () => InAppPurchaseSourceImpl(), // Old payment method (kept for reference)
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

/// Send Player ID to backend
// Future<void> _sendPlayerIdToBackend(String userId, String playerId) async {
//   try {
//     final token = getStorageData.readString(getStorageData.tokenKey);
    
//     // TODO: Replace 'users/update-onesignal-id' with your actual backend API endpoint
//     // This endpoint should accept: user_id and onesignal_player_id
//     final data = await APIFunction().apiCall(
//       apiName: 'users/update-onesignal-id',
//       withOutFormData: jsonEncode({
//         'user_id': userId,
//         'onesignal_player_id': playerId,
//       }),
//       token: token ?? '',
//     );
    
//     debugPrint('✅ Player ID sent to backend successfully');
//     debugPrint('Backend response: $data');
//   } catch (e) {
//     debugPrint('❌ Error sending Player ID to backend: $e');
//     debugPrint('💡 Make sure your backend API endpoint is correct');
//     debugPrint('💡 Endpoint should be: users/update-onesignal-id (or your custom endpoint)');
//   }
// }

/// Main application widget that sets up the app's theme, routing, and state management.
/// 
/// This widget initializes:
/// - Material app with custom theme
/// - GetX routing system
/// - Authentication BLoC provider
/// - EasyLoading for loading indicators
/// - Sizer for responsive design
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: BlocProvider(
                create: (context) => AuthBloc(),
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeLight().theme,
                  builder: EasyLoading.init(),
                  initialRoute: AppPages.INITIAL,
                  getPages: AppPages.routes,
                ),
              ),
            ));
  }
}
