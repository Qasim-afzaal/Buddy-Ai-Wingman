import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/gather_new_chat_info_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class NameWidget extends StatefulWidget {
  const NameWidget({super.key});

  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  final GatherNewChatInfoController controller = GatherNewChatInfoController();
  bool isLoading = false;

  void _onButtonPressed() async {
    setState(() => isLoading = true); // Show loader

    await Future.delayed(Duration(seconds: 5));

    setState(() => isLoading = false); // Hide loader

    Get.toNamed(Routes.CHAT); // Navigate to chat
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.allSet,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(10),
        Text(
          AppStrings.allSetDescription,
          textAlign: TextAlign.center,
          style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w400, height: 1),
        ),
        SB.h(40),
        CustomTextField(
          controller: controller.nameController,
          title: AppStrings.name,
        ),
        SB.h(25),
        AppButton.primary(
          title: isLoading
              ? null // Remove text when loading
              : AppStrings.getMybuddy_ai_wingman,
          onPressed: isLoading ? null : _onButtonPressed, // Disable while loading
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white, // Match button text color
                  ),
                )
              : null, // Only show child if loading
        ),
      ],
    ).paddingAll(context.paddingDefault);
  }
}
