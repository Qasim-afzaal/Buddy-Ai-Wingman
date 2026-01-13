import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import 'package:buddy/core/constants/app_colors.dart';

class Loading {
  Loading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.hourGlass
      ..contentPadding = const EdgeInsets.all(18)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 50.04
      ..lineWidth = 2
      ..radius = 15
      ..boxShadow = <BoxShadow>[]
      ..progressColor = AppColors.transparent
      ..backgroundColor = AppColors.transparent
      ..indicatorColor = AppColors.transparent
      ..textColor = AppColors.transparent
      ..maskColor = AppColors.transparent
      ..maskType = EasyLoadingMaskType.custom
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(
      status: text,
      indicator: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.black,
        size: 50,
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: false,
    );
  }

  static void toast(String text) {
    EasyLoading.showToast(text, duration: Duration(seconds: 2));
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}

