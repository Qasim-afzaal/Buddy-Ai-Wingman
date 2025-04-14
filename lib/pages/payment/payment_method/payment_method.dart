import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_method/payment_method_controller.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.paymentMethods,
      ),
      body: GetBuilder<PaymentMethodController>(
        init: PaymentMethodController(),
        builder: (controller) {
          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _Container(
                    data: controller.paymentMethodsList[index],
                    selectedPaymentMethod: controller.selectedPaymentMethod,
                    onPaymentMethodSelection:
                        controller.onPaymentMethodSelection,
                  );
                },
                separatorBuilder: (context, index) {
                  return SB.h(0);
                },
                itemCount: controller.paymentMethodsList.length,
              ),
              AppButton.primary(
                title: AppStrings.pay,
                onPressed: controller.navigateToPaymentConfirmation,
              )
            ],
          ).paddingAll(context.paddingDefault);
        },
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {super.key,
      required this.data,
      this.selectedPaymentMethod,
      required this.onPaymentMethodSelection});

  final PaymentUIModel data;
  final String? selectedPaymentMethod;

  final Function(String) onPaymentMethodSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primary,
              context.secondary,
            ]),
      ),
      child: InkWell(
        onTap: () => onPaymentMethodSelection(data.title),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: data.title == selectedPaymentMethod
                ? context.cardColor
                : context.scaffoldBackgroundColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              data.image.svg(width: 36),
              SB.w(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.title,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (data.description != null)
                      Column(
                        children: [
                          SB.h(4),
                          Text(
                            data.description!,
                            style: context.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentUIModel {
  final String title;
  final SvgGenImage image;
  final String? description;

  PaymentUIModel({required this.title, required this.image, this.description});
}
