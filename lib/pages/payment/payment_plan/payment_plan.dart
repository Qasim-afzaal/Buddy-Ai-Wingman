import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_plan/subscription_box.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';

class PaymentPlanPage extends StatefulWidget {
  const PaymentPlanPage({super.key});

  @override
  _PaymentPlanPageState createState() => _PaymentPlanPageState();
}

class _PaymentPlanPageState extends State<PaymentPlanPage> {
  String selectedPlan = ""; // To track the selected subscription plan

  void selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  void onSubscription() {
   Get.offNamed(Routes.DASHBOARD,);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> randomTextItems = [
      "First random text",
      "Second random text",
      "Another line of text",
      "Yet another random text item",
    ];

    return Scaffold(
      appBar: const buddy_ai_wingmanAppBarBeforePayment(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: randomTextItems.map((text) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: GoogleFonts.interTight(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SB.h(context.height * 0.06),
            const SizedBox(height: 20),
            SB.h(context.height * 0.06),
            Text(
              "Unlimited Content \nWhenever you need it.",
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Choose Plan",
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SubscriptionBox(
                  plan: "Basic",
                  price: "€9,99",
                  description:
                      "5 AI-powered replies per week and unlimited AI-powered Opening lines.",
                  isSelected: selectedPlan == "Basic",
                  onSelect: () => selectPlan("Basic"),
                ),
                SubscriptionBox(
                  plan: "Pro",
                  price: "€14,99",
                  description: "Unlimited use of features.",
                  isSelected: selectedPlan == "Pro",
                  onSelect: () => selectPlan("Pro"),
                ),
              ],
            ),
            SB.h(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton.primary(
                title: "Continue",
                onPressed: onSubscription,
              ),
            ),
            SB.h(10),
            Text(
              Platform.isIOS
                  ? AppStrings.subscriptionWillRenewIOS
                  : AppStrings.subscriptionWillRenewAnd,
              textAlign: TextAlign.center,
              style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400, height: 1, fontSize: 13),
            ).paddingAll(4),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      const url =
                          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      "Terms of Use",
                      textAlign: TextAlign.center,
                      style: context.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle restore purchase logic
                    },
                    child: Text(
                      "Restore",
                      textAlign: TextAlign.center,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize:
                            MediaQuery.of(context).size.height >= 667.0 &&
                                    MediaQuery.of(context).size.height <= 710.0
                                ? 14
                                : 15,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      const url =
                          'https://fancy-bubblegum-216efa.netlify.app/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      "Privacy Policy",
                      textAlign: TextAlign.center,
                      style: context.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
