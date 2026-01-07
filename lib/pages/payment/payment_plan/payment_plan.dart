import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/payment/payment_plan/payment_plan_controller.dart'
    show PaymentPlanController;
import 'package:flutter/cupertino.dart';
import 'package:buddy/pages/payment/payment_plan/subscription_box.dart';
import 'package:buddy/routes/app_pages.dart';
import 'package:buddy/main.dart';

class PaymentPlanPage extends StatefulWidget {
  const PaymentPlanPage({super.key});

  @override
  _PaymentPlanPageState createState() => _PaymentPlanPageState();
}

class _PaymentPlanPageState extends State<PaymentPlanPage> {
  String selectedPlan = ""; // To track the selected subscription plan

  String basicProductId = "com.app.buddy.basic";
  String proProductId = "com.app.buddy.pro";

  void selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  void onSubscription() {
    /*   Get.offNamed(
      Routes.DASHBOARD,
    );*/
    var productID = selectedPlan == "Basic" ? basicProductId : proProductId;

    // Use the existing controller instead of creating a new one
    var controller = getPaymentPlanController();
    if (controller.isLoading.value == false) {
      controller.onSubscriptionPressed(productID);
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> randomTextItems = [
      "Slimme antwoorden die werken",
      "Gesprekken in jouw stijl",
      "Openingszinnen met impact",
      "Scoor meer dates",
    ];

    return Scaffold(
      appBar: const SparkdAppBarBeforePayment(),
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
            SB.h(context.height * 0.04),
            const SizedBox(height: 10),
            SB.h(context.height * 0.04),
            Text(
              "De slimme wingman die 24/7 voor je klaarstaat.",
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Kies jouw plan.",
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SubscriptionBox(
                  plan: "Buddy Basic",
                  price: "€9,99 / maand",
                  description:
                      "+ 5 slimme AI-antwoorden per week\n+ Onbeperkte openingszinnen die werken\nPerfect voor wie af en toe hulp wil in zijn gesprekken.",
                  isSelected: selectedPlan == "Basic",
                  onSelect: () => selectPlan("Basic"),
                ),
                SubscriptionBox(
                  plan: "Buddy Pro",
                  price: "€14,99 / maand",
                  description:
                      "+ Onbeperkte AI-antwoorden en openingszinnen\nVoor wie altijd het perfecte antwoord wil, elke keer weer.",
                  isSelected: selectedPlan == "Pro",
                  onSelect: () => selectPlan("Pro"),
                ),
              ],
            ),
            SB.h(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton.primary(
                title: "Continue",
                onPressed: onSubscription,
              ),
            ),
            SB.h(5),
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
              padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 20),
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
                      var controller = PaymentPlanController(
                          inAppPurchaseSource: Get.find());
                      controller.onRestorePurchased((p0) {
                        debugPrint("Verification Api Called Status::$p0");
                        Map msg = {
                          "name": "Api Called Navigate base on Status$p0 ..."
                        };
                        Constants.socket!.emit("logEvent", msg);
                        if (p0 == true) {
                          debugPrint("Navigating to Dashboard...");
                          Constants.socket!.emit("logEvent", {
                            "name":
                                "Verification Done Navigate to Dashboard ..."
                          });
                          /*if (getStorageData
                              .readLoginData()
                              .data!
                              .isProfileComplete ==
                              false) {
                            Get.offNamed(Routes.ON_BOARDING);
                          } else {
                            Get.offNamed(Routes.DASHBOARD);
                          }*/
                          Get.offNamed(Routes.DASHBOARD);
                        } else {
                          debugPrint("Navigating to Paywall...");
                          Constants.socket!.emit("logEvent", {
                            "name": "Verification Done Navigate to PayWall ..."
                          });
                          Get.offNamed(Routes.PAYMENT_PLAN);
                        }
                      });
                    },
                    child: Text(
                      "Restore",
                      textAlign: TextAlign.center,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: MediaQuery.of(context).size.height >= 667.0 &&
                                MediaQuery.of(context).size.height <= 710.0
                            ? 14
                            : 15,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      const url = 'https://fancy-bubblegum-216efa.netlify.app/';
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
          ],
        ),
      ),
    );
  }
}
