import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  // function to change the status bar color for the whole app
  changeStatusBarColor() {
    return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}