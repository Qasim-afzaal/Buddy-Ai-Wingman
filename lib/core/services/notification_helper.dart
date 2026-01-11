import 'package:buddy/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Helper class with common notification use cases
class NotificationHelper {
  static final NotificationService _notificationService =
      NotificationService.instance;

  /// Show a simple notification immediately
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    await _notificationService.showLocalNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  /// Schedule a reminder notification
  static Future<void> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledTime,
    int id = 1,
  }) async {
    await _notificationService.scheduleLocalNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
    );
  }

  /// Schedule a daily reminder
  static Future<void> scheduleDailyReminder({
    required String title,
    required String body,
    required DateTime time,
    int id = 2,
  }) async {
    await _notificationService.scheduleLocalNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: time,
      repeatDaily: true,
    );
  }

  /// Schedule trial end reminder (example)
  static Future<void> scheduleTrialEndReminder({
    required DateTime trialEndDate,
    int daysBefore = 2,
  }) async {
    final reminderDate = trialEndDate.subtract(Duration(days: daysBefore));
    
    if (reminderDate.isAfter(DateTime.now())) {
      await _notificationService.scheduleLocalNotification(
        id: 100,
        title: 'Trial Ending Soon',
        body: 'Your free trial ends in $daysBefore days. Subscribe now to continue!',
        scheduledDate: reminderDate,
        payload: 'trial_ending',
      );
      debugPrint('Trial end reminder scheduled for: $reminderDate');
    }
  }

  /// Schedule multiple reminders for trial end
  static Future<void> scheduleTrialEndReminders({
    required DateTime trialEndDate,
  }) async {
    // Reminder 3 days before
    final reminder3Days = trialEndDate.subtract(const Duration(days: 3));
    if (reminder3Days.isAfter(DateTime.now())) {
      await _notificationService.scheduleLocalNotification(
        id: 101,
        title: 'Trial Ending in 3 Days',
        body: 'Your free trial ends soon. Don\'t miss out!',
        scheduledDate: reminder3Days,
        payload: 'trial_ending_3_days',
      );
    }

    // Reminder 1 day before
    final reminder1Day = trialEndDate.subtract(const Duration(days: 1));
    if (reminder1Day.isAfter(DateTime.now())) {
      await _notificationService.scheduleLocalNotification(
        id: 102,
        title: 'Trial Ending Tomorrow',
        body: 'Your free trial ends tomorrow. Subscribe now!',
        scheduledDate: reminder1Day,
        payload: 'trial_ending_1_day',
      );
    }

    // Reminder on trial end day
    if (trialEndDate.isAfter(DateTime.now())) {
      await _notificationService.scheduleLocalNotification(
        id: 103,
        title: 'Trial Ended Today',
        body: 'Your free trial has ended. Subscribe to continue using the app!',
        scheduledDate: trialEndDate,
        payload: 'trial_ended',
      );
    }
  }

  /// Cancel trial reminders
  static Future<void> cancelTrialReminders() async {
    await _notificationService.cancelNotification(100);
    await _notificationService.cancelNotification(101);
    await _notificationService.cancelNotification(102);
    await _notificationService.cancelNotification(103);
    debugPrint('Trial reminders cancelled');
  }

  /// Schedule a chat reminder (example)
  static Future<void> scheduleChatReminder({
    required String chatName,
    required DateTime reminderTime,
    int id = 200,
  }) async {
    await _notificationService.scheduleLocalNotification(
      id: id,
      title: 'Chat Reminder',
      body: 'Don\'t forget to check your chat with $chatName!',
      scheduledDate: reminderTime,
      payload: 'chat_reminder',
    );
  }

  /// Show notification when app receives a message (local notification)
  static Future<void> showMessageNotification({
    required String senderName,
    required String message,
    int id = 300,
  }) async {
    await _notificationService.showLocalNotification(
      id: id,
      title: 'New message from $senderName',
      body: message,
      payload: 'new_message',
      channelId: 'messages',
      channelName: 'Messages',
    );
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    return await _notificationService.requestPermissions();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationService.getPendingNotifications();
  }

  /// Set user ID for push notifications
  static Future<void> setUserId(String userId) async {
    await _notificationService.setUserId(userId);
  }

  /// Logout user from notifications
  static Future<void> logout() async {
    await _notificationService.logout();
  }

  /// Set user tags for push notifications
  static Future<void> setUserTags(Map<String, String> tags) async {
    await _notificationService.setUserTags(tags);
  }
}

