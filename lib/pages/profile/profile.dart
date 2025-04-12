import 'package:google_fonts/google_fonts.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/profile/profile_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';
import 'package:buddy_ai_wingman/widgets/confirmation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.profile,
      ),
      body: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          getStorageData.getUserId();
          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, 
            children: [
              SizedBox(
                height: 20,
              ),
            
              _Tile(
                iconPath: Assets.icons.deleteAll.path,
                title: AppStrings.clearAll,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.clearAll,
                    description: AppStrings.clearAllDescription,
                    onConfirmation: () {
                      Get.offNamed(Routes.SIGN_UP);
                    },
                  ),
                ),
              ),
              _Tile(
                iconPath: Assets.icons.logout.path,
                title: AppStrings.logout,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.logout,
                    description: AppStrings.logoutDescription,
                    onConfirmation: () {
                      Get.offNamed(Routes.SIGN_UP);
                    },
                  ),
                ),
              ),
              _Tile(
                iconPath: Assets.icons.deleteAll.path,
                title: "Delete Account",
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: "Delete Account",
                    description: AppStrings.deletetDescription,
                    onConfirmation: () {
                      Get.offNamed(Routes.SIGN_UP);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.iconPath, required this.title, this.onTap});

  final String iconPath, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
            color: Colors.black, // Set icon color to black
          ),
          SB.w(10),
          Expanded(
              child: Text(title,
                  style: GoogleFonts.interTight(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ))),
        ],
      ).paddingAll(15),
    );
  }
}
