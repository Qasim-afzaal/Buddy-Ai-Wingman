import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:buddy_ai_wingman/core/Widgets/custom_button.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/pages/auth/otp/otp_verification/otp_verification_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OtpVerificationController>(
        init: OtpVerificationController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Headline Text
                        Text(
                          'Enter OTP Code',
                          style: GoogleFonts.interTight(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Email Information
                        Text(
                          'An OTP has been sent to your email:',
                          style: GoogleFonts.interTight(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '${controller.email}',
                          style: GoogleFonts.interTight(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // OTP Input using pin_code_fields
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            activeColor: AppColors.blackColor,
                            selectedColor: AppColors.blackColor,
                            inactiveColor: AppColors.greyColor,
                          ),
                          onChanged: (value) {
                            controller.otpController.text = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Buttons Row
                        Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: CustomButton(
                                onTap: () => Get.offNamed(Routes.SIGN_UP),
                                buttonText: 'Cancel',
                                backGroundColor: Colors.transparent,
                                textColor: AppColors.blackColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Done Button
                            Expanded(
                              child: CustomButton(
                                onTap: () => controller.codeVerification(),
                                buttonText: 'Done',
                                backGroundColor: AppColors.blackColor,
                                textColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
