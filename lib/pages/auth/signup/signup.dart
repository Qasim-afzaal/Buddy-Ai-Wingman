import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:buddy_ai_wingman/core/Utils/assets_util.dart';
import 'package:buddy_ai_wingman/core/Utils/custom_text_styles.dart';
import 'package:buddy_ai_wingman/core/Widgets/custom_button.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/signup/signup_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';
import 'package:buddy_ai_wingman/widgets/custom_rich_text.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Register into \nBuddy Ai Wingman",
                                style: GoogleFonts.interTight(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      4), // Add spacing between title and subtitle
                              Text(
                                "Enter the info required below",
                                style: GoogleFonts.interTight(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Add spacing between text and image
                        Image.asset(
                          "assets/images/Logi.png",
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),

                    SB.h(25),
                    CustomTextField(
                      controller: controller.userNameController,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Enter Password",
                      isPasswordField: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SB.h(15),
                    CustomButton(
                      buttonText: "Sign in",
                      onTap: () async {
                        // Check connectivity status before proceeding
                        // var connectivityResult =
                        //     await Connectivity().checkConnectivity();

                        // // Print the result for debugging
                        // print('Connectivity Result: $connectivityResult');

                        // if (connectivityResult != ConnectivityResult.none) {
                        //   // If internet is available, proceed with the API call
                        if (controller.formKey.currentState!.validate()) {
                          await controller.onSignup();
                        }

                        //   } else {
                        //     // No internet connection, show snackbar and stop further execution
                        //     Get.snackbar(
                        //       "No Internet",
                        //       "Please check your internet connection and try again.",
                        //       snackPosition: SnackPosition.BOTTOM,
                        //     );
                        //     return; // Prevent the API call by returning here
                        //   }
                      },
                    ),

                    // AppButton.primary(
                    //   title: AppStrings.signUp,
                    //   onPressed: () async {
                    //     // Check connectivity status before proceeding
                    //     var connectivityResult =
                    //         await Connectivity().checkConnectivity();

                    //     // Print the result for debugging
                    //     print('Connectivity Result: $connectivityResult');

                    //     if (connectivityResult != ConnectivityResult.none) {
                    //       // If internet is available, proceed with the API call
                    //       controller.emailVerifi();
                    //     } else {
                    //       // No internet connection, show snackbar and stop further execution
                    //       Get.snackbar(
                    //         "No Internet",
                    //         "Please check your internet connection and try again.",
                    //         snackPosition: SnackPosition.BOTTOM,
                    //       );
                    //       return; // Prevent the API call by returning here
                    //     }
                    //   },
                    // ),

                    SB.h(context.height * 0.03),

                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "OR CONTINUE WITH",
                          style: GoogleFonts.interTight(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 10)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SB.h(12),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     AppButton.borderIcon(
                    //       onTap: () async {
                    //         // Check connectivity status before proceeding
                    //         var connectivityResult =
                    //             await Connectivity().checkConnectivity();

                    //         // Print the result for debugging
                    //         print('Connectivity Result: $connectivityResult');

                    //         if (connectivityResult != ConnectivityResult.none) {
                    //           // If internet is available, proceed with Google login
                    //           controller.loginWithGoogle(context);
                    //         } else {
                    //           // No internet connection, show snackbar and stop further execution
                    //           Get.snackbar(
                    //             "No Internet",
                    //             "Please check your internet connection and try again.",
                    //             snackPosition: SnackPosition.BOTTOM,
                    //           );
                    //           return; // Prevent the API call by returning here
                    //         }
                    //       },
                    //       icon: Assets.icons.google.svg(),
                    //     ),
                    //     if (Platform.isIOS) ...[
                    //       SB.w(15),
                    //       AppButton.borderIcon(
                    //         onTap: () async {
                    //           // Check connectivity status before proceeding
                    //           var connectivityResult =
                    //               await Connectivity().checkConnectivity();

                    //           // Print the result for debugging
                    //           print('Connectivity Result: $connectivityResult');

                    //           if (connectivityResult != ConnectivityResult.none) {
                    //             // If internet is available, proceed with the Apple sign-in
                    //             controller.signInWithApple(context);
                    //           } else {
                    //             // No internet connection, show snackbar and stop further execution
                    //             Get.snackbar(
                    //               "No Internet",
                    //               "Please check your internet connection and try again.",
                    //               snackPosition: SnackPosition.BOTTOM,
                    //             );
                    //             return; // Prevent the API call by returning here
                    //           }
                    //         },
                    //         icon: Assets.icons.apple.svg(),
                    //       ),
                    //     ]
                    //   ],
                    // ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              //  Get.offNamed(Routes.PAYMENT_PLAN);

                              // // Check connectivity status before proceeding
                              // var connectivityResult =
                              //     await Connectivity().checkConnectivity();

                              // // Print the result for debugging
                              // print('Connectivity Result: $connectivityResult');

                              // if (connectivityResult != ConnectivityResult.none) {
                              //   // If internet is available, proceed with Google login
                              //   controller.loginWithGoogle(context);
                              // } else {
                              //   // No internet connection, show snackbar and stop further execution
                              //   Get.snackbar(
                              //     "No Internet",
                              //     "Please check your internet connection and try again.",
                              //     snackPosition: SnackPosition.BOTTOM,
                              //   );
                              //   return; // Prevent the API call by returning here
                              // }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.textFieldBorderColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    CustomImages.googleIcon,
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Google",
                                    style: GoogleFonts.interTight(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (Platform.isIOS) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                // Get.offNamed(Routes.PAYMENT_PLAN);
                                // // Check connectivity status before proceeding
                                // var connectivityResult =
                                //     await Connectivity().checkConnectivity();

                                // // Print the result for debugging
                                // print('Connectivity Result: $connectivityResult');

                                // if (connectivityResult !=
                                //     ConnectivityResult.none) {
                                //   // If internet is available, proceed with the signInWithApple method
                                //   controller.signInWithApple(context);
                                // } else {
                                //   // No internet connection, show snackbar and stop further execution
                                //   Get.snackbar(
                                //     "No Internet",
                                //     "Please check your internet connection and try again.",
                                //     snackPosition: SnackPosition.BOTTOM,
                                //   );
                                //   return; // Prevent the method call by returning here
                                // }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.textFieldBorderColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.icons.apple.svg(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Apple",
                                      style: GoogleFonts.interTight(
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    SB.h(context.height * 0.1),
                    TextButton(
                      child: Text("Already have an account?",
                          style: headingTextStyle(
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Get.offNamed(Routes.LOGIN);
                      },
                    ),

                    SB.h(context.height * 0.05),
                    // CustomRichText(
                    //   text: AppStrings.alreadyHaveAccount,
                    //   highlightedText: AppStrings.login,
                    //   onTap: controller.onLogin,
                    // ),
                    // SB.h(context.height * 0.05),
                  ],
                ).paddingAll(context.paddingDefault),
              ),
            ),
          ),
        );
      },
    );
  }
}
