import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/new_chat/gather_new_chat/gather_new_chat_info_controller.dart';
import 'package:buddy/routes/app_pages.dart';

class NameWidget extends StatefulWidget {
  const NameWidget({super.key});

  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  final GatherNewChatInfoController controller = GatherNewChatInfoController();
  bool isLoading = false;

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
          style: context.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w400, height: 1),
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
              : AppStrings.getMySparkd,
          onPressed: isLoading
              ? null
              : controller.onButtonPressed, // Disable while loading
          child: isLoading
              ? const SizedBox(
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
