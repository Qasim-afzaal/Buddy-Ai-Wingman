import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:buddy/core/constants/constants.dart';

/// Service to fetch and manage device ID for both iOS and Android
class DeviceService {
  static DeviceService? _instance;
  static DeviceService get instance {
    _instance ??= DeviceService._();
    return _instance!;
  }

  DeviceService._();

  String? _deviceId;
  bool _initialized = false;

  /// Get device ID (cached after first fetch)
  String? get deviceId => _deviceId;

  /// Check if device ID has been fetched
  bool get isInitialized => _initialized;

  /// Fetch device ID for iOS or Android
  /// This should be called when app starts
  Future<String?> fetchDeviceId() async {
    if (_initialized && _deviceId != null) {
      debugPrint('Device ID already fetched: $_deviceId');
      return _deviceId;
    }

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        debugPrint('iOS Device ID (identifierForVendor): $deviceId');
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        debugPrint('Android Device ID: $deviceId');
      } else {
        debugPrint('Platform not supported for device ID');
        return null;
      }

      if (deviceId != null && deviceId.isNotEmpty) {
        _deviceId = deviceId;
        _initialized = true;
        
        // Save to storage for later use
        getStorageData.saveString(getStorageData.deviceId, deviceId);
        debugPrint('Device ID saved to storage: $deviceId');
      }

      return deviceId;
    } catch (e) {
      debugPrint('Error fetching device ID: $e');
      return null;
    }
  }

  /// Get device ID from storage (if already saved)
  String? getDeviceIdFromStorage() {
    try {
      final storedId = getStorageData.readString(getStorageData.deviceId);
      if (storedId != null && storedId.isNotEmpty) {
        _deviceId = storedId;
        _initialized = true;
        debugPrint('Device ID loaded from storage: $storedId');
        return storedId;
      }
    } catch (e) {
      debugPrint('Error reading device ID from storage: $e');
    }
    return null;
  }

  /// Get device information (model, OS version, etc.)
  Future<Map<String, String?>> getDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      Map<String, String?> info = {};

      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        info = {
          'platform': 'iOS',
          'deviceId': iosInfo.identifierForVendor,
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'localizedModel': iosInfo.localizedModel,
          'utsname': iosInfo.utsname.machine,
        };
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        info = {
          'platform': 'Android',
          'deviceId': androidInfo.id,
          'brand': androidInfo.brand,
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'device': androidInfo.device,
          'product': androidInfo.product,
          'androidId': androidInfo.id,
          'systemVersion': 'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})',
        };
      }

      return info;
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return {};
    }
  }

  /// Clear device ID (useful for logout)
  void clearDeviceId() {
    _deviceId = null;
    _initialized = false;
    debugPrint('Device ID cleared');
  }
}

