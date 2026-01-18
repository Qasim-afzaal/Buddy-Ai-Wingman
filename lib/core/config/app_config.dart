import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration class to access environment variables
/// All sensitive keys and API endpoints are loaded from .env file
class AppConfig {
  // RevenueCat API Keys
  static String get revenueCatAppleApiKey =>
      dotenv.env['REVENUECAT_APPLE_API_KEY'] ?? '';

  static String get revenueCatGoogleApiKey =>
      dotenv.env['REVENUECAT_GOOGLE_API_KEY'] ?? '';

  // Firebase Configuration - Android
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';

  static String get firebaseAndroidAppId =>
      dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';

  static String get firebaseAndroidMessagingSenderId =>
      dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] ?? '';

  static String get firebaseAndroidProjectId =>
      dotenv.env['FIREBASE_ANDROID_PROJECT_ID'] ?? '';

  static String get firebaseAndroidStorageBucket =>
      dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET'] ?? '';

  // Firebase Configuration - iOS
  static String get firebaseIosApiKey =>
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';

  static String get firebaseIosAppId =>
      dotenv.env['FIREBASE_IOS_APP_ID'] ?? '';

  static String get firebaseIosMessagingSenderId =>
      dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID'] ?? '';

  static String get firebaseIosProjectId =>
      dotenv.env['FIREBASE_IOS_PROJECT_ID'] ?? '';

  static String get firebaseIosStorageBucket =>
      dotenv.env['FIREBASE_IOS_STORAGE_BUCKET'] ?? '';

  // API Base URLs
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://3.123.108.18:3000/api/';

  static String get socketBaseUrl =>
      dotenv.env['SOCKET_BASE_URL'] ?? 'http://3.123.108.18:3000/';

  /// Initialize the environment variables
  /// Call this in main() before runApp()
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
  
  /// Check if environment variables are loaded
  static bool get isLoaded => dotenv.isInitialized;
}

