
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton2 extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final Color? backGroundColor;
  final Color? textColor;
  const CustomButton2({super.key, this.onTap, required this.buttonText, this.backGroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: 
             Border.all(color: AppColors.textFieldBorderColor) ,
            color: backGroundColor ?? AppColors.blackColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(buttonText, style: GoogleFonts.interTight(textStyle: TextStyle(color: textColor ?? AppColors.whiteColor, fontWeight: FontWeight.w500, fontSize: 12, )),),
        )
    );
  }
}
