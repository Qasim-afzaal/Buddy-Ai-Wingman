import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/profile_before_payment/profile_before_payment_controller.dart';
import 'package:buddy_ai_wingman/widgets/confirmation_widget.dart';

class ProfilePageBeforePayment extends StatelessWidget {
  const ProfilePageBeforePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.profile,
      ),
      body: GetBuilder<ProfileBeforePaymentController>(
        init: ProfileBeforePaymentController(),
        builder: (controller) {
            final userId = getStorageData.getUserId();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(20),
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subscription",
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "buddy_ai_wingman GOLD",
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "\$6.99 / Every week",
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ).paddingAll(15),
              Divider(
                color: context.primary,
              ),*/
              // _Tile(
              //   iconPath: Assets.icons.pin.path,
              //   title: getStorageData.readBoolean(key: getStorageData.isPinCreated) ? AppStrings.changePin : AppStrings.createPin,
              //   onTap: () => Get.to(() => const CreatePinPage()),
              // ),
              // _Tile(
              //   iconPath: Assets.icons.deleteAll.path,
              //   title: AppStrings.clearAll,
              //   onTap: () => Get.bottomSheet(
              //     ConfirmationWidget(
              //       title: AppStrings.clearAll,
              //       description: AppStrings.clearAllDescription,
              //       onConfirmation: () {
              //         Get.back();
              //         controller.deleteAllChat();
              //       },
              //     ),
              //   ),
              // ),
              _Tile(
                iconPath: Assets.icons.logout.path,
                title: AppStrings.logout,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.logout,
                    description: AppStrings.logoutDescription,
                    onConfirmation: () {
                      getStorageData.removeAllData();
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
                    description: AppStrings.deletetaccont,
                    onConfirmation: () {
                      controller.deleteAccount();
                       print("User ID: $userId");
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
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: Colors.black,
              ),
              SB.w(10),
              Expanded(
                child: Text(
                  title,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ).paddingAll(15),
        ),
        Divider(
          color: context.primary,
        )
      ],
    );
  }
}
