import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:buddy/core/Utils/assets_util.dart';
import 'package:buddy/core/constants/app_colors.dart';

class CustomAlertDialogue extends StatelessWidget {
  final void Function()? onContinueTapped;
  final void Function()? onSignOutTapped;
  final bool? showShowContinue;
  final String contextText;
  const CustomAlertDialogue(
      {super.key,
      this.onContinueTapped,
      this.onSignOutTapped,
      this.showShowContinue,
      required this.contextText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: AppColors.fieldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            CustomImages.notificationBellIcon,
            width: 124,
            height: 124,
          ),
          Text(
            contextText,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onSignOutTapped,
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Sign out",
                    style: GoogleFonts.interTight(
                        textStyle: const TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                  ),
                ),
              ),
            ),
            if (showShowContinue ?? true) ...[
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onContinueTapped,
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.interTight(
                          textStyle: const TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}
