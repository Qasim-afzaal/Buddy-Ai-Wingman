import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:buddy/core/services/onesignal_service.dart';

/// Unified Notification Service for both Push and Local Notifications
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _localNotificationsInitialized = false;
  bool _timezoneInitialized = false;

  /// Initialize both push and local notifications
  Future<void> initialize({
    required String iosOneSignalAppId,
    required String androidOneSignalAppId,
  }) async {
    // Initialize timezone data for scheduled notifications
    if (!_timezoneInitialized) {
      tz.initializeTimeZones();
      _timezoneInitialized = true;
    }

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Initialize OneSignal for push notifications
    await OneSignalService.instance.initialize(
      iosAppId: iosOneSignalAppId,
      androidAppId: androidOneSignalAppId,
    );
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsInitialized) {
      debugPrint('Local notifications already initialized');
      return;
    }

    try {
      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize the plugin
      final bool? initialized = await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        _localNotificationsInitialized = true;
        debugPrint('Local notifications initialized successfully');

        // Request permissions
        await requestPermissions();
      } else {
        debugPrint('Failed to initialize local notifications');
      }
    } catch (e) {
      debugPrint('Error initializing local notifications: $e');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    // Handle navigation or action based on payload
    // You can use Get.toNamed() or Navigator here
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ requires runtime permission
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted = await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
    } else if (Platform.isIOS) {
      // iOS permissions are requested during initialization
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final bool? granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }
    return false;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        return await androidImplementation.areNotificationsEnabled() ?? false;
      }
    }
    // For iOS, we assume permissions are granted if initialized successfully
    return _localNotificationsInitialized;
  }

  /// Show immediate local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
    String? channelName,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    if (!_localNotificationsInitialized) {
      debugPrint('Local notifications not initialized');
      return;
    }

    try {
      // Android notification details
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId ?? 'default_channel',
        channelName ?? 'Default Channel',
        channelDescription: 'Default notification channel',
        importance: importance,
        priority: priority,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      // iOS notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combined notification details
      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );

      debugPrint('Local notification shown: $title');
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Schedule a local notification
  Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? channelId,
    String? channelName,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    bool repeatDaily = false,
  }) async {
    if (!_localNotificationsInitialized) {
      debugPrint('Local notifications not initialized');
      return;
    }

    try {
      // Android notification details
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId ?? 'scheduled_channel',
        channelName ?? 'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: importance,
        priority: priority,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      // iOS notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combined notification details
      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Convert DateTime to TZDateTime
      final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      if (repeatDaily) {
        // Schedule daily repeating notification
        await _localNotifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTime,
          details,
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else {
        // Schedule one-time notification
        await _localNotifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTime,
          details,
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      debugPrint('Local notification scheduled: $title at $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling local notification: $e');
    }
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    debugPrint('Notification cancelled: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    debugPrint('All notifications cancelled');
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Show notification with custom actions (Android)
  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    String? payload,
    List<AndroidNotificationAction>? actions,
  }) async {
    if (!_localNotificationsInitialized) {
      debugPrint('Local notifications not initialized');
      return;
    }

    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'action_channel',
        'Action Notifications',
        channelDescription: 'Notifications with action buttons',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        actions: actions,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Error showing notification with actions: $e');
    }
  }

  /// Set user ID for push notifications (OneSignal)
  Future<void> setUserId(String userId) async {
    await OneSignalService.instance.setUserId(userId);
  }

  /// Logout user from push notifications (OneSignal)
  Future<void> logout() async {
    await OneSignalService.instance.logout();
  }

  /// Set user tags for push notifications (OneSignal)
  Future<void> setUserTags(Map<String, String> tags) async {
    await OneSignalService.instance.setUserTags(tags);
  }

  /// Get OneSignal player ID (synchronous - may be null if not ready yet)
  String? get playerId => OneSignalService.instance.playerId;

  /// Get OneSignal player ID asynchronously (waits for it to be available)
  Future<String?> getPlayerId() async {
    return await OneSignalService.instance.getPlayerId();
  }

  /// Check if local notifications are initialized
  bool get isLocalNotificationsInitialized => _localNotificationsInitialized;

  /// Check if OneSignal is initialized
  bool get isPushNotificationsInitialized =>
      OneSignalService.instance.isInitialized;
}

