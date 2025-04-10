import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'pin_success_controller.dart';

class PinSuccessPage extends StatelessWidget {
  const PinSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.pinCreated,
      ),
      body: GetBuilder<PinSuccessController>(
        init: PinSuccessController(),
        builder: (controller) {
          return Column(
            children: [
              SB.h(20),
              Text(
                AppStrings.pinCreatedSuccess,
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SB.h(60),
              Assets.icons.checkOutline.svg(),
              SB.h(60),
              AppButton.primary(
                title: AppStrings.goBackToProfile,
                onPressed: controller.backToProfile,
              ),
            ],
          ).paddingAll(context.paddingDefault);
        },
      ),
    );
  }
}
