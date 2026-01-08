import 'package:buddy/core/constants/imports.dart';

import 'start_sparkd_controller.dart';

class StartSparkdPage extends StatelessWidget {
  const StartSparkdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StartSparkdController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    AppStrings.startASparkd,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SB.h(30),
                  Container(
                    height: context.height * 0.55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: Assets.images.uploadScreenShot.provider(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        utils.openImagePicker(
                          context,
                          onPicked: (pickFile) {
                            pickFile.forEach((element) async {
                              controller.imagePath = element;
                              // Get.back();
                              controller.addNewChatManually(false);
                            });
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.upload.svg(),
                          SB.h(10),
                          Text(
                            AppStrings.uploadScreenShot,
                            textAlign: TextAlign.center,
                            style: context.bodyLarge?.copyWith(
                              color: context.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SB.h(20),
                  Text(
                    AppStrings.or,
                    textAlign: TextAlign.center,
                    style: context.titleSmall?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppButton.outline(
                    title: AppStrings.enterManually,
                    onPressed: () {
                      controller.addNewChatManually(true);
                    },
                  ).paddingSymmetric(
                      horizontal: context.width * 0.15,
                      vertical: context.paddingDefault),
                ],
              ).paddingAll(context.paddingDefault),
            ),
          ),
        );
      },
    );
  }
}
