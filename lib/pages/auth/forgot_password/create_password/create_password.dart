import 'package:google_fonts/google_fonts.dart';

import 'package:buddy/core/components/custom_button.dart';
import 'package:buddy/core/constants/app_colors.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/routes/app_pages.dart';

import 'create_password_controller.dart';

class CreatePasswordPage extends StatelessWidget {
  const CreatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CreatePasswordController>(
        init: CreatePasswordController(),
        builder: (controller) {
          return Scaffold(
            // appBar: SimpleAppBar(
            //   title: controller.isForgetPin ? AppStrings.forgotYourPin : AppStrings.forgotPassword,
            // ),
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
                          'Create Password',
                          style: GoogleFonts.interTight(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // New Password Field
                        CustomTextField(
                          controller: controller.newPassword,
                          hintText: 'New Password',
                          prefixIcon: Icon(Icons.password),
                          textInputAction: TextInputAction.done,
                          isPasswordField: true,
                        ),
                        const SizedBox(height: 15),
                        // Confirm Password Field
                        CustomTextField(
                          controller: controller.confirmNewPassword,
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(Icons.password),
                          textInputAction: TextInputAction.done,
                          isPasswordField: true,
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
                                // onTap: () {
                                //   Get.offNamed(Routes.PAYMENT_PLAN);
                                // },
                                onTap: () => controller.isForgetPin
                                    ? controller.changePin
                                    : controller.changePassword,
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

              // Column(
              //   children: [
              //     SB.h(30),
              //     Text(
              //       controller.isForgetPin ? AppStrings.createNewPin : AppStrings.createNewPassword,
              //       textAlign: TextAlign.center,
              //       style: context.headlineMedium?.copyWith(
              //         color: context.primary,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     SB.h(context.height * 0.05),
              //     CustomTextField(
              //       controller: controller.newPassword,
              //       title: controller.isForgetPin ? AppStrings.enterPin : AppStrings.enterNewPassword,
              //       isPasswordField: true,
              //       maxLength: controller.isForgetPin ? 4 : null,
              //     ),
              //     CustomTextField(
              //       controller: controller.confirmNewPassword,
              //       title: controller.isForgetPin ? AppStrings.confirmPin : AppStrings.confirmPassword,
              //       isPasswordField: true,
              //       maxLength: controller.isForgetPin ? 4 : null,
              //       textInputAction: TextInputAction.done,
              //     ),
              //     SB.h(20),
              //     AppButton.primary(
              //       title: controller.isForgetPin ? AppStrings.confirmPin : AppStrings.confirmPassword,
              //       onPressed: controller.isForgetPin ? controller.changePin : controller.changePassword,
              //     )
              //   ],
              // ).paddingAll(context.paddingDefault),
            ),
          );
        },
      ),
    );
  }
}
