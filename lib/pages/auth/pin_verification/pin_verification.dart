import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/pin_verification/pin_verification_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class PinVerificationPage extends StatelessWidget {
  const PinVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PinVerificationController>(
        init: PinVerificationController(),
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Assets.icons.logoBlack.svg().paddingSymmetric(vertical: context.paddingDefault),
                  Text(
                    "${AppStrings.welcomeBack}\n ${getStorageData.readString(getStorageData.userName)}",
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(5),
                  Text(
                    AppStrings.enterYourPin,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(context.height * 0.1),
                  CustomTextField(
                    isPasswordField: true,
                    controller: controller.pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textInputAction: TextInputAction.done,
                    onChange: (value) {
                      if (value.length == 4) {
                        controller.loginWithPin();
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () => Get.bottomSheet(const _BiometricWidget()),
                      child: Text(
                        AppStrings.useBiometricVerification,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SB.h(context.height * 0.1),
                  GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.EMAIL_VERIFICATION,
                      arguments: {
                        HttpUtil.isForgetPin: true,
                      },
                    ),
                    child: Text(
                      AppStrings.forgotYourPin,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ).paddingAll(context.paddingDefault),
            ),
          );
        },
      ),
    );
  }
}

class _BiometricWidget extends StatelessWidget {
  const _BiometricWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: context.scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SB.h(10),
            Text(
              AppStrings.loginTobuddy_ai_wingman,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SB.h(8),
            Text(
              AppStrings.confirmYourIdentity,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SB.h(25),
            Assets.icons.fingerprint.svg(),
            SB.h(25),
            Text(
              AppStrings.touchTheFingerPrint,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SB.h(30),
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: Get.back,
                child: Text(
                  AppStrings.usePin,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ).paddingAll(context.paddingDefault),
      ),
    );
  }
}
