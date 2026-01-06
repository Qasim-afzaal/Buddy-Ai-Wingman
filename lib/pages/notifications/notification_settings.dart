import 'package:flutter/cupertino.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/terms_condition/terms_condition.dart';

import 'notification_settings_controller.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.notifications,
      ),
      body: GetBuilder<NotificationSettingsController>(
        init: NotificationSettingsController(),
        builder: (controller) {
          return Column(
            children: [
              SB.h(40),
              _Tile(
                isSelected: controller.chatNotifications,
                title: AppStrings.chat,
                subTitle: AppStrings.chatDescription,
                onTap: (value) => controller.chatNotifications.value = value,
              ),
              _Tile(
                isSelected: controller.chatUpdates,
                title: AppStrings.chatUpdates,
                subTitle: AppStrings.chatUpdatesDescription,
                onTap: (value) => controller.chatUpdates.value = value,
              ),
              _Tile(
                isSelected: controller.appUpdates,
                title: AppStrings.appUpdates,
                subTitle: AppStrings.appUpdatesDescription,
                onTap: (value) => controller.appUpdates.value = value,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
      {super.key,
      required this.subTitle,
      required this.title,
      required this.onTap,
      required this.isSelected});

  final String subTitle, title;
  final Function(bool) onTap;
  final RxBool isSelected;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () => onTap(!isSelected.value),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subTitle,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: isSelected.value,
                  onChanged: onTap,
                  activeColor: context.primary,
                  trackColor: context.chatBubbleColor,
                ),
              ],
            ).paddingAll(15),
          ),
          Divider(
            color: context.primary,
          )
        ],
      ),
    );
  }
}
