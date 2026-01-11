import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:buddy/core/constants/constants.dart';

/// OneSignal Service for push notifications
class OneSignalService {
  static OneSignalService? _instance;
  static OneSignalService get instance {
    _instance ??= OneSignalService._();
    return _instance!;
  }

  OneSignalService._();

  bool _initialized = false;
  String? _playerId;
  String? _userId;

  /// Initialize OneSignal with App ID
  /// Replace 'YOUR_ONESIGNAL_APP_ID' with your actual OneSignal App ID
  Future<void> initialize({
    required String iosAppId,
    required String androidAppId,
  }) async {
    if (_initialized) {
      debugPrint('OneSignal already initialized');
      return;
    }

    try {
      // Set App ID based on platform
      String appId = defaultTargetPlatform == TargetPlatform.iOS 
          ? iosAppId 
          : androidAppId;

      // Initialize OneSignal - this sets the App ID
      OneSignal.initialize(appId);

      // Set up notification handlers
      _setupNotificationHandlers();


      // Request permission for notifications (required for Player ID)
      // This will trigger the Player ID generation
      try {
        final hasPermission = await OneSignal.Notifications.requestPermission(true);
        debugPrint('OneSignal notification permission requested: $hasPermission');
      } catch (e) {
        debugPrint('Error requesting notification permission: $e');
      }

      // Get player ID after initialization
      // Wait a bit for subscription to be ready
      await Future.delayed(const Duration(milliseconds: 1000));
      try {
        _playerId = await OneSignal.User.pushSubscription.id;
        debugPrint('OneSignal Player ID: $_playerId');
      } catch (e) {
        debugPrint('Player ID not available yet: $e');
      }
      
      // Set up observer for future changes (this will catch Player ID when it becomes available)
      OneSignal.User.pushSubscription.addObserver((state) {
        final currentId = state.current.id;
        if (currentId != null && currentId.isNotEmpty) {
          _playerId = currentId;
          debugPrint('✅ OneSignal Player ID updated: $_playerId');
        } else if (currentId != null) {
          _playerId = currentId;
        debugPrint('OneSignal Player ID updated: $_playerId');
        }
      });

      // Set up user ID if available
      final userId = getStorageData.getUserId();
      if (userId != null) {
        await setUserId(userId);
      }

      _initialized = true;
      debugPrint('OneSignal initialized successfully');
    } catch (e) {
      debugPrint('Error initializing OneSignal: $e');
    }
  }

  /// Set up notification event handlers
  void _setupNotificationHandlers() {
    // Handle notification received while app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint('Notification received in foreground: ${event.notification.body}');
      // Notification will be displayed by default
      // You can customize the notification display here if needed
    });

    // Handle notification clicked/opened
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('Notification clicked: ${event.notification.body}');
      // Handle notification click - navigate to specific screen, etc.
      _handleNotificationClick(event.notification);
    });

    // Handle permission changes
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint('Push subscription state changed: ${state.current.id}');
      _playerId = state.current.id;
    });
  }

  /// Handle notification click
  void _handleNotificationClick(OSNotification notification) {
    final additionalData = notification.additionalData;
    if (additionalData != null) {
      final type = additionalData['type'] as String?;
      final screen = additionalData['screen'] as String?;

      debugPrint('Notification type: $type, screen: $screen');
      // You can navigate to specific screens based on notification data
      // Example: Get.toNamed(screen ?? Routes.HOME);
    }
  }

  /// Set user ID for targeted notifications (External ID)
  Future<void> setUserId(String userId) async {
    try {
      _userId = userId;
      await OneSignal.login(userId);
      debugPrint('OneSignal External ID (user ID) set: $userId');
    } catch (e) {
      debugPrint('Error setting OneSignal user ID: $e');
    }
  }

  /// Logout user from OneSignal
  Future<void> logout() async {
    try {
      await OneSignal.logout();
      _userId = null;
      debugPrint('OneSignal user logged out');
    } catch (e) {
      debugPrint('Error logging out from OneSignal: $e');
    }
  }

  /// Set user tags for segmentation
  Future<void> setUserTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
      debugPrint('OneSignal tags set: $tags');
    } catch (e) {
      debugPrint('Error setting OneSignal tags: $e');
    }
  }

  /// Set trial end date tag for scheduling notifications
  Future<void> setTrialEndDate(DateTime trialEndDate) async {
    try {
      final daysRemaining = trialEndDate.difference(DateTime.now()).inDays;
      await OneSignal.User.addTags({
        'trial_end_date': trialEndDate.toIso8601String(),
        'trial_days_remaining': daysRemaining.toString(),
        'has_trial': 'true',
      });
      debugPrint('Trial end date set: $trialEndDate, days remaining: $daysRemaining');
    } catch (e) {
      debugPrint('Error setting trial end date: $e');
    }
  }

  /// Remove trial tags when user subscribes
  Future<void> removeTrialTags() async {
    try {
      await OneSignal.User.removeTags(['trial_end_date', 'trial_days_remaining', 'has_trial']);
      await OneSignal.User.addTags({'has_trial': 'false', 'is_subscribed': 'true'});
      debugPrint('Trial tags removed, subscription tag added');
    } catch (e) {
      debugPrint('Error removing trial tags: $e');
    }
  }

  /// Get player ID (synchronous - may be null if not ready yet)
  String? get playerId => _playerId;

  /// Get player ID asynchronously (waits for it to be available)
  Future<String?> getPlayerId() async {
    if (_playerId != null && _playerId!.isNotEmpty) {
      return _playerId;
    }

    // Wait for player ID to be available
    int attempts = 0;
    while (attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        _playerId = await OneSignal.User.pushSubscription.id;
        if (_playerId != null && _playerId!.isNotEmpty) {
          debugPrint('OneSignal Player ID retrieved: $_playerId');
          return _playerId;
        }
      } catch (e) {
        debugPrint('Waiting for Player ID... attempt ${attempts + 1}');
      }
      attempts++;
    }

    debugPrint('Player ID not available after waiting');
    return null;
  }

  /// Get user ID
  String? get userId => _userId;

  /// Check if initialized
  bool get isInitialized => _initialized;
}

