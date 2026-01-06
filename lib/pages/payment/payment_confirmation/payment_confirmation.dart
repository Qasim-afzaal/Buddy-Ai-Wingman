import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/home/home.dart';

import 'payment_confirmation_controller.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentConfirmationController>(
      init: PaymentConfirmationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.paymentConfirmation,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your payment was successful! Enjoy your premium experience.",
                    textAlign: TextAlign.center,
                    style: context.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppButton.primary(
                    title: AppStrings.letsGo,
                    onPressed: () => Get.offAll(() => HomePage()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
