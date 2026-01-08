import 'package:buddy/core/constants/imports.dart';

import 'create_account_controller.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CreateAccountController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.createAccountBackground.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.everythingSetup,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  Text(
                    AppStrings.createAccountDescription,
                    textAlign: TextAlign.center,
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(35),
                  AppButton.primary(
                    title: AppStrings.createAccount,
                    onPressed: controller.createAccount,
                  ).paddingAll(context.paddingDefault),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
