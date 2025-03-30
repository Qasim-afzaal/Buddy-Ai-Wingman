import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/widgets/age_widget.dart';
import 'package:buddy_ai_wingman/widgets/gender_widget.dart';
import 'package:buddy_ai_wingman/widgets/personality_widget.dart';

import '../../../widgets/custom_rich_text.dart';
import 'onBoarding_controller.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        init: OnBoardingController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Visibility(
                      visible: controller.currentPage.value > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: InkWell(
                        onTap: controller.previousPage,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back),
                            SB.w(5),
                            Text(
                              AppStrings.back,
                              style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ).paddingAll(context.paddingDefault),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => _PageIndicator(
                          isCurrentPage: controller.currentPage.value == 0,
                        ),
                      ),
                      Obx(
                        () => _PageIndicator(
                          isCurrentPage: controller.currentPage.value == 1,
                        ),
                      ),
                      Obx(
                        () => _PageIndicator(
                          isCurrentPage: controller.currentPage.value == 2,
                        ),
                      ),
                    ],
                  ),
                  SB.h(25),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (index) => controller.currentPage.value = index,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GenderWidget(
                          selectedGender: controller.selectedGender,
                          onGenderSelection: controller.onGenderSelection,
                        ),
                        AgeWidget(
                          selectedAge: controller.selectedAgeRange,
                          onAgeSelection: controller.onAgeSelection,
                        ),
                        PersonalityWidget(
                          selectedPersonality: controller.selectedPersonality,
                          onPersonalitySelection: controller.onPersonalitySelection,
                          onFinish: controller.onFinish,
                        ),
                      ],
                    ),
                  ),
                  Center(

                    child: CustomRichText(
                      text: AppStrings.alreadyHaveAccount,
                      highlightedText: AppStrings.login,
                      onTap: controller.onLogin,
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({this.isCurrentPage = false});

  final bool isCurrentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: context.width * (isCurrentPage ? 0.48 : 0.25),
      // duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentPage ? null : context.grey,
        gradient: isCurrentPage
            ? LinearGradient(colors: [
                context.primary,
                context.secondary,
              ])
            : null,
      ),
    );
  }
}
