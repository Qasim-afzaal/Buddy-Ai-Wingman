import 'package:buddy_ai_wingman/pages/payment/payment_confirmation/payment_confirmation.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_method/payment_method.dart';

import '../../../core/constants/imports.dart';

class PaymentMethodController extends GetxController {
  String? selectedPaymentMethod;

  final List<PaymentUIModel> paymentMethodsList = [
    PaymentUIModel(
        title: "Master Card",
        image: Assets.icons.mastercard,
        description: 'xxxx - xxxx - xxxx - 8973'),
    PaymentUIModel(
      title: "Apple pay",
      image: Assets.icons.applepay,
    ),
    PaymentUIModel(
      title: "Google pay",
      image: Assets.icons.googlePay,
    ),
  ];

  void onPaymentMethodSelection(String paymentMethod) {
    if (paymentMethod != selectedPaymentMethod) {
      selectedPaymentMethod = paymentMethod;

      update();
    }
  }

  void navigateToPaymentConfirmation() =>
      Get.to(() => const PaymentConfirmationPage());
}
