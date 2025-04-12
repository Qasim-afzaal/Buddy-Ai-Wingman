import 'package:buddy_ai_wingman/core/constants/imports.dart';

class ConfirmationWidget extends StatelessWidget {
  const ConfirmationWidget(
      {super.key, this.title, this.description, this.onConfirmation});
  final String? title, description;
  final VoidCallback? onConfirmation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: context.scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SB.h(10),
            if (title != null)
              Text(
                title!,
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            SB.h(15),
            if (description != null)
              Text(
                description!,
                style: context.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            SB.h(25),
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    title: AppStrings.cancel,
                    onPressed: Get.back,
                  ),
                ),
                SB.w(10),
                Expanded(
                  child: AppButton.primary(
                    title: AppStrings.yes,
                    onPressed: onConfirmation,
                  ),
                )
              ],
            ),
          ],
        ).paddingAll(context.paddingDefault),
      ),
    );
  }
}
