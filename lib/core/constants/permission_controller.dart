import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandle {
  //android
  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.CAMERA" />
  ///<uses-permission android:name="android.permission.RECORD_AUDIO" />

  /// info.plist
  ///<key>NSCameraUsageDescription</key>
  // <string>App needs camera permission to work</string>
  Future<bool> cameraAndVideoPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    PermissionStatus? statusCamera = await Permission.camera.status;
    PermissionStatus? statusMicrophone = await Permission.microphone.status;

    bool isGranted = statusCamera == PermissionStatus.granted && statusMicrophone == PermissionStatus.granted;
    if (isGranted) {
      return true;
    }
    bool isPermanentlyDenied = statusCamera == PermissionStatus.permanentlyDenied || statusMicrophone == PermissionStatus.permanentlyDenied;
    if (!isPermanentlyDenied) {
      openAppSettings();

      return false;
    } else {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      return false;
    }
  }

  /// mamifest in permission set
  //<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  //<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  //<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
  //<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
  Future<bool> storagePermission() async {
    bool isLatest = false;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        isLatest = true;
      }

      if (isLatest) {
        await [
          Permission.photos,
          Permission.videos,
        ].request();

        PermissionStatus statusPhotos = await Permission.photos.status;
        PermissionStatus statusVideo = await Permission.videos.status;

        if (statusPhotos.isGranted && statusVideo.isGranted) {
          return true;
        } else if (statusPhotos.isDenied || statusVideo.isDenied) {
          await [
            Permission.storage,
            Permission.photos,
            Permission.videos,
          ].request();
          return false;
        } else {
          openAppSettings();
          return false;
        }
      } else {
        await Permission.storage.request();

        PermissionStatus statusStorage = await Permission.storage.status;

        if (statusStorage.isGranted) {
          return true;
        } else if (statusStorage.isDenied) {
          await Permission.storage.request();

          return false;
        } else {
          openAppSettings();
          return false;
        }
      }
    } else {
      PermissionStatus statusStorage = await Permission.storage.request();

      if (statusStorage.isGranted) {
        return true;
      } else if (statusStorage.isDenied) {
        await Permission.storage.request();
        storagePermission();
        return false;
      } else {
        openAppSettings();
        return false;
      }
    }
  }

  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.CAMERA" />
  Future<bool> cameraPermission() async {
    PermissionStatus statusCamera = await Permission.camera.request();

    if (statusCamera.isGranted) {
      return true;
    } else if (statusCamera.isDenied) {
      await Permission.camera.request();
      cameraPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.CAMERA" />
  ///<uses-permission android:name="android.permission.RECORD_AUDIO" />
  Future<bool> VideoPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    PermissionStatus statusCamera = await Permission.camera.status;
    PermissionStatus statusMicroPhone = await Permission.microphone.status;

    if (statusCamera.isGranted && statusMicroPhone.isGranted) {
      return true;
    } else if (statusCamera.isDenied || statusMicroPhone.isDenied) {
      await Permission.camera.request();
      await Permission.microphone.request();
      VideoPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  /// <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  //  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  Future<bool> locationPermission() async {
    PermissionStatus statusLocation = await Permission.location.request();

    if (statusLocation.isGranted) {
      return true;
    } else if (statusLocation.isDenied) {
      await Permission.location.request();
      locationPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.RECORD_AUDIO"/>
  Future<bool> audioPermission() async {
    PermissionStatus statusAudio = await Permission.audio.request();

    if (statusAudio.isGranted) {
      return true;
    } else if (statusAudio.isDenied) {
      await Permission.audio.request();
      audioPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.RECORD_AUDIO"/>
  Future<bool> notificationPermission() async {
    await Permission.notification.request();

    PermissionStatus statusNotification = await Permission.notification.status;

    if (statusNotification.isGranted) {
      return true;
    } else if (statusNotification.isDenied) {
      await Permission.notification.request();
      notificationPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  ///<uses-permission android:name="android.permission.READ_CONTACTS" />
  /// <uses-permission android:name="android.permission.WRITE_CONTACTS" />
  Future<bool> contactPermission() async {
    PermissionStatus statusContacts = await Permission.contacts.request();

    if (statusContacts.isGranted) {
      return true;
    } else if (statusContacts.isDenied) {
      await Permission.contacts.request();
      contactPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  /// <uses-permission android:name="android.permission.READ_CALENDAR" />
  /// <uses-permission android:name="android.permission.WRITE_CALENDAR" />
  Future<bool> calendarPermission() async {
    PermissionStatus statusCalendar = await Permission.calendarFullAccess.request();

    if (statusCalendar.isGranted) {
      return true;
    } else if (statusCalendar.isDenied) {
      await Permission.calendarFullAccess.request();
      calendarPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  /// <uses-permission android:name="android.permission.BLUETOOTH_SCAN"  />
  // <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
  // <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"  />
  // <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"  />
  Future<bool> phonePermission() async {
    PermissionStatus statusPhone = await Permission.phone.request();

    if (statusPhone.isGranted) {
      return true;
    } else if (statusPhone.isDenied) {
      await Permission.phone.request();
      phonePermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  /// mamifest in permission set
  /// <uses-permission android:name="android.permission.SEND_SMS" />
  Future<bool> smsPermission() async {
    PermissionStatus statusSms = await Permission.sms.request();

    if (statusSms.isGranted) {
      return true;
    } else if (statusSms.isDenied) {
      await Permission.sms.request();
      smsPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }

  // mamifest in permission set
  ///<uses-permission android:name="android.permission.BLUETOOTH" />
  ///<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
  // <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
  Future<bool> bluetoothPermission() async {
    PermissionStatus statusBluetooth = await Permission.bluetooth.request();

    if (statusBluetooth.isGranted) {
      return true;
    } else if (statusBluetooth.isDenied) {
      await Permission.bluetooth.request();
      bluetoothPermission();
      return false;
    } else {
      openAppSettings();
      return false;
    }
  }
}
