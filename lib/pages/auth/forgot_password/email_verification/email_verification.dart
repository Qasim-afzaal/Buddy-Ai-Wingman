import 'package:google_fonts/google_fonts.dart';

import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import 'email_verification_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EmailVerificationController>(
        init: EmailVerificationController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SB.h(30),
                  Text(AppStrings.verification,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SB.h(5),
                  Text(
                    AppStrings.verificationDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.interTight(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SB.h(context.height * 0.1),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: AppStrings.enterEmail,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  SB.h(20),
                  AppButton.primary(
                    title: AppStrings.send,
                    // onPressed:(){ Get.offNamed(Routes.CODE_VERIFICATION,);},
                    onPressed: controller.emailVerification,
                  )
                ],
              ).paddingAll(context.paddingDefault),
            ),
          );
        },
      ),
    );
  }
}
