import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buddy/pages/payment/payment_plan/subscription_box.dart';
import 'package:buddy/routes/app_pages.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/terms_condition/terms_condition.dart';

import 'payment_plan_controller.dart';

class PaymentPlanPage extends StatelessWidget {
  const PaymentPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> randomTextItems = [
      "First random text",
      "Second random text",
      "Another line of text",
      "Yet another random text item",
    ];

    print("Screen Height: ${MediaQuery.of(context).size.height}");
    return GetBuilder(
      init: PaymentPlanController(inAppPurchaseSource: Get.find()),
      builder: (controller) {
        return Scaffold(
          appBar: const SparkdAppBarBeforePayment(),
          body: SafeArea(
            child: Column(
              children: [
                // Text(
                //   AppStrings.infiniteSparkd,
                //   textAlign: TextAlign.center,
                //   style: context.headlineMedium?.copyWith(
                //     color: context.primary,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ).paddingSymmetric(vertical: context.height * 0.02),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: randomTextItems.map((text) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check, // Check icon
                            color: Colors.green, // Icon color
                            size: 18, // Icon size
                          ),
                          const SizedBox(
                              width: 8), // Space between icon and text
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _Column(
                //       icon: Assets.images.sparks,
                //       text: AppStrings.unlimitedSparks,
                //     ),
                //     _Column(
                //       icon: Assets.images.coach,
                //       text: AppStrings.personalCoach,
                //     ),
                //     _Column(
                //       icon: Assets.images.dates,
                //       text: AppStrings.provenDates,
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(
                  height: 5,
                ),
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
                SizedBox(
                  height: 5,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SubscriptionBox(
                      plan: "Basic",
                      price: "€9,99",
                      description:
                          "5 AI-powered replies per week and unlimited AI-powered Opening lines.",
                      isSelected: true,
                      onSelect: () {},
                    ),
                    SubscriptionBox(
                      isSelected: true,
                      onSelect: () {},
                      plan: "Pro",
                      price: "€14,99",
                      description: "Unlimited use of features.",
                    ),
                  ],
                ),
                // Stack(
                //   clipBehavior: Clip.none,
                //   children: [
                //     Container(
                //       height: context.height * 0.31,
                //       padding: EdgeInsets.all(context.paddingDefault),
                //       decoration: BoxDecoration(
                //         color: context.cardColor,
                //         borderRadius: BorderRadius.circular(18),
                //         border: Border.all(color: context.primary),
                //       ),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           SizedBox(
                //             height: 6,
                //           ),
                //           Text(
                //             "Get Unlimited sparks/chat with your premium \nRizz Coach Paid Subscription",
                //             textAlign: TextAlign.center,
                //             style: context.headlineMedium?.copyWith(
                //                 fontWeight: FontWeight.w600,
                //                 fontSize: 14,
                //                 color: Theme.of(context).colorScheme.primary),
                //           ),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Text(
                //             AppStrings.flameOn,
                //             textAlign: TextAlign.center,
                //             style: context.headlineMedium?.copyWith(
                //                 fontWeight: FontWeight.w600, fontSize: 17),
                //           ),
                //           SizedBox(
                //             height: 15,
                //           ),
                //           AppButton.primary(
                //             title: AppStrings.unlockFreeTrial,
                //             onPressed: () {
                //               if (controller.isLoading.value == false) {
                //                 controller.onSubscriptionPressed();
                //               } else {
                //                 null;
                //               }
                //             },
                //           ),
                //           SizedBox(
                //             height: 5,
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Assets.images.flame.image(height: 16),
                //               SB.w(8),
                //               Text(
                //                 AppStrings.freeTrial,
                //                 textAlign: TextAlign.center,
                //                 style: context.bodyLarge?.copyWith(
                //                     fontWeight: FontWeight.w500,
                //                     height: 1,
                //                     fontSize:
                //                         (MediaQuery.of(context).size.height >=
                //                                     667.0 &&
                //                                 MediaQuery.of(context)
                //                                         .size
                //                                         .height <=
                //                                     710.0)
                //                             ? 14
                //                             : 15.5),
                //               ),
                //               SB.w(8),
                //               Assets.images.flame.image(height: 16),
                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       left: 0,
                //       right: 0,
                //       top: (MediaQuery.of(context).size.height >= 667.0 &&
                //               MediaQuery.of(context).size.height <= 710.0)
                //           ? -45
                //           : -55,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Assets.images.flameGroup.image(
                //               scale: (MediaQuery.of(context).size.height >=
                //                           667.0 &&
                //                       MediaQuery.of(context).size.height <=
                //                           710.0)
                //                   ? 3
                //                   : 2),
                //         ],
                //       ),
                //     ),
                //   ],
                // ).paddingSymmetric(horizontal: context.paddingDefault),
                SB.h(20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton.primary(
                    title: AppStrings.unlockFreeTrial,
                    onPressed: () {
                      if (controller.isLoading.value == false) {
                        controller.onSubscriptionPressed("");
                      } else {
                        null;
                      }
                    },
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
                          // AppStrings.termsConditions,
                          textAlign: TextAlign.center,
                          style: context.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              // decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                              height: 1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          controller.onRestorePurchased((p0) {
                            print("Verification Api Called Status::$p0");
                            Map msg = {
                              "name":
                                  " Api Called Navigate base on Status$p0 ..."
                            };

                            Constants.socket!.emit("logEvent", msg);
                            if (p0 == true) {
                              print("i am heredashbord.....");
                              Map msg = {
                                "name":
                                    "Verification Done Navigate to Dashboad ..."
                              };
                              print("i am hereRecipt Verification.....");
                              Constants.socket!.emit("logEvent", msg);
                              Get.offNamed(Routes.DASHBOARD);
                            } else {
                              print("i am here Paywalll.....");
                              Map msg = {
                                "name":
                                    " Verification Done Navigate to PayWall ..."
                              };

                              Constants.socket!.emit("logEvent", msg);
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
                              fontSize: (MediaQuery.of(context).size.height >=
                                          667.0 &&
                                      MediaQuery.of(context).size.height <=
                                          710.0)
                                  ? 14
                                  : 15),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          const url =
                              'https://fancy-bubblegum-216efa.netlify.app/'; // Replace with your Privacy Policy URL
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          " Privacy Policy",
                          textAlign: TextAlign.center,
                          style: context.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              // decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                              height: 1),
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
      },
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({super.key, required this.icon, required this.text});

  final AssetGenImage icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon.image(
          height: (MediaQuery.of(context).size.height >= 667.0 &&
                  MediaQuery.of(context).size.height <= 710.0)
              ? 40
              : 60,
          width: (MediaQuery.of(context).size.height >= 667.0 &&
                  MediaQuery.of(context).size.height <= 710.0)
              ? 40
              : 60,
        ),
        SB.h(15),
        Text(
          text,
          textAlign: TextAlign.center,
          style: context.titleMedium
              ?.copyWith(fontWeight: FontWeight.w400, height: 1),
        ),
      ],
    );
  }
}
