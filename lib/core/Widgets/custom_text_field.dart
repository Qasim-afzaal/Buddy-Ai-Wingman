import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/app_colors.dart';

/// Custom text field widget

class CustomTextField extends StatelessWidget {
  final Function()? onTap;
  final TextEditingController controller;
  final IconData? iconData;
  final String hint;
  final bool? editable;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  const CustomTextField({super.key, this.onTap, required this.controller, this.iconData, required this.hint, this.editable, this.keyboardType, this.suffix,  this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      keyboardType: keyboardType,
      enabled: editable,
      controller: controller,
      obscureText: obscureText ?? false,
      style:  GoogleFonts.interTight(textStyle: const TextStyle(
        color: AppColors.blackColor,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
      ),),
      cursorColor: AppColors.secondaryColor,
      decoration: InputDecoration(
        prefixIcon: iconData != null ? Icon(
            iconData,
            color: AppColors.blackColor
        ) : null,
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textFieldBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textFieldBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(15),
        ),
      hintText: hint,
        hintStyle: GoogleFonts.interTight(textStyle: const TextStyle(
          color: AppColors.textHintColor,
          fontSize: 12,
        ),),
        fillColor: AppColors.fieldBackgroundColor,
        filled: true,
      ),
    );
  }
}
