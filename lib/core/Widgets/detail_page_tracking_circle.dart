import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

/// Detail page tracking circle widget

import 'package:buddy/core/constants/app_colors.dart';

class DetailPageTrackingCircle extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final String circleText;
  final String label;

  const DetailPageTrackingCircle(
      {super.key,
      required this.isActive,
      required this.isCompleted,
      required this.circleText,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.successColor
                    : isActive
                        ? AppColors.blackColor
                        : AppColors.skinToneColor),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.blackColor,
                  )
                : Text(
                    circleText,
                    style: GoogleFonts.interTight(
                        textStyle: TextStyle(
                            color: isActive
                                ? AppColors.secondaryColor
                                : AppColors.blackColor)),
                  ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
          )
        ],
      ),
    );
  }
}
