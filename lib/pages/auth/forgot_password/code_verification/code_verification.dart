import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:buddy/core/components/custom_button.dart';
import 'package:buddy/core/constants/app_colors.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/routes/app_pages.dart';

import 'code_verification_controller.dart';

class CodeVerificationPage extends StatelessWidget {
  const CodeVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CodeVerificationController>(
        init: CodeVerificationController(),
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
                          'test@gmail.com',
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

                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  controller.codeVerification();
                                },
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

          //     return Scaffold(

          //       body: SingleChildScrollView(
          //         child: SafeArea(
          //           child: Column(
          //             children: [
          //               SB.h(30),
          //               Text(
          //                 AppStrings.verifyYourMail,
          //                 textAlign: TextAlign.center,
          //                 style: context.headlineMedium?.copyWith(
          //                   color: context.primary,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               SB.h(20),
          //               Text(
          //                 AppStrings.verifyYourMailDescription +
          //                     controller.emailValue!.toString(),
          //                 textAlign: TextAlign.center,
          //                 style: context.bodyLarge?.copyWith(
          //                   fontWeight: FontWeight.w400,
          //                 ),
          //               ),
          //               SB.h(30),
          //               Text(
          //                 "The code in the email will only be valid for 10 minutes.\nBe sure to also check your spam folder.",
          //                 style: TextStyle(
          //                   fontSize: 14,
          //                   color: Colors.grey[600],
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ).paddingAll(5),
          //               SB.h(context.height * 0.05),
          //               CustomTextField(
          //                 controller: controller.otpController,
          //                 keyboardType: TextInputType.number,
          //                 textInputAction: TextInputAction.done,
          //                 maxLength: 4,
          //               ),
          //               SB.h(5),
          //               AppButton.primary(
          //                 title: AppStrings.verify,
          //                 onPressed: controller.codeVerification,
          //               )
          //             ],
          //           ).paddingAll(context.paddingDefault),
          //         ),
          //       ),
          //     );
        },
      ),
    );
  }
}
