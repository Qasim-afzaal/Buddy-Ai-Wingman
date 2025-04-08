import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy_ai_wingman/core/components/custom_button2.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/home_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const buddy_ai_wingmanAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return Column(
                  children: [
                    SB.h(context.height * 0.02),
                    Text(
                      "Upload a screenshot\n of a chat or bio",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SB.h(20),
                    Container(
                      height: context.height * 0.28,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/back.png"),
                          fit: BoxFit.cover,
                          opacity: 0.5,
                        ),
                      ),
                    ),
                    SB.h(context.height * 0.12),
                    AppButton.primary(
                      title: "Upload a screenshot",
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.none) {
                          utils.openImagePicker(
                            context,
                            onPicked: (pickFile) {
                              pickFile.forEach((element) async {
                                controller.imagePath = element;
                                controller.uploadImage();
                              });
                            },
                          );
                        }
                      },
                    ).paddingSymmetric(vertical: 10),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton2(
                            onTap: () => Get.toNamed(Routes.MANUAL_CHAT),
                            buttonText: 'Manual Chat',
                            backGroundColor: AppColors.fieldBackgroundColor,
                            textColor: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButton2(
                            onTap: () {
                              controller.startChat();
                            },
                            buttonText: 'Get Pickup Lines',
                            backGroundColor: AppColors.fieldBackgroundColor,
                            textColor: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    SB.h(10),
                  ],
                ).paddingAll(context.paddingDefault);
              },
            ),
            // Full-screen loader
            Obx(() => controller.isLoading.value
                ? Container(
                    color: Colors.transparent,
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                      color: Colors.black,
                      size: 50,
                    )),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
