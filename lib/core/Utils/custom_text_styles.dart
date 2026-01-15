import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Custom text style utilities
bodyTextStyle({double? size = 12, Color color = AppColors.blackColor}) {
  return  GoogleFonts.interTight(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size,
      ));
}

headingTextStyle({double? size = 12, Color color = AppColors.blackColor, TextDecoration? decoration, FontWeight? fontWeight = FontWeight.w500}) {
  return  GoogleFonts.interTight(
      textStyle: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
        decoration: decoration
      ));
}