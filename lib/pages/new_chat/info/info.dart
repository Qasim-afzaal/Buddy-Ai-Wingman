import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/new_chat/info/info_controller.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: InfoController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.knowPersonBackground.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.knowThePerson,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  Text(
                    AppStrings.knowThePersonDescription,
                    textAlign: TextAlign.center,
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(35),
                  AppButton.primary(
                    title: AppStrings.next,
                    onPressed: controller.onNext,
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
