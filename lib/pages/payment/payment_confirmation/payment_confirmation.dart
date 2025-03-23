import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'payment_confirmation_controller.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PaymentConfirmationController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.paymentConfirmation.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.paymentConfirmation,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  Text(
                    AppStrings.paymentConfirmationDescription,
                    textAlign: TextAlign.center,
                    style: context.titleLarge?.copyWith(
                      color: context.onPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(35),
                  AppButton.primary(
                    title: AppStrings.letsGo,
                    onPressed: () => Get.offAll(() => const DashboardPage()),
                  ).paddingAll(context.paddingDefault),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
