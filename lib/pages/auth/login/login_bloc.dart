import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:buddy/core/Utils/custom_text_styles.dart';
import 'package:buddy/core/Widgets/custom_button.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/bloc/auth/auth_bloc.dart';
import 'package:buddy/bloc/auth/auth_event.dart';
import 'package:buddy/bloc/auth/auth_state.dart';

import '../../../api_repository/api_class.dart';
import '../../../routes/app_pages.dart';

class LoginBlocPage extends StatefulWidget {
  const LoginBlocPage({super.key});

  @override
  State<LoginBlocPage> createState() => _LoginBlocPageState();
}

class _LoginBlocPageState extends State<LoginBlocPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFields() {
    // Field validation logic can be added here if needed
  }

  bool _isLoginValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(_emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(_emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    } else if (utils.isValidationEmpty(_passwordController.text)) {
      utils.showToast(message: AppStrings.errorEmptyPassword);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign in to \nBuddy Ai Wingman",
                            style: GoogleFonts.interTight(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
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
                    const SizedBox(width: 8),
                    Image.asset(
                      "assets/images/Logi.png",
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                SB.h(40),
                CustomTextField(
                  controller: _emailController,
                  prefixIcon: Icon(Icons.email),
                  hintText: AppStrings.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                ),
                CustomTextField(
                  controller: _passwordController,
                  prefixIcon: Icon(Icons.password),
                  hintText: AppStrings.enterPassword,
                  textInputAction: TextInputAction.done,
                  isPasswordField: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.EMAIL_VERIFICATION, arguments: {
                      HttpUtil.isForgetPin: false,
                    }),
                    child: Text(
                      AppStrings.forgotPassword,
                      textAlign: TextAlign.center,
                      style: context.bodyLarge?.copyWith(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SB.h(25),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      utils.showToast(message: state.message);
                    } else if (state is AuthNavigationRequired) {
                      if (state.arguments != null) {
                        Get.offNamed(state.route, arguments: state.arguments);
                      } else {
                        Get.offNamed(state.route);
                      }
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      buttonText: "Sign in",
                      onTap: state is AuthLoading ? null : () {
                        if (_isLoginValidation()) {
                          context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                SB.h(MediaQuery.of(context).size.height * 0.03),
                TextButton(
                  child: Text(
                    "Don't have an account?",
                    style: headingTextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Get.offNamed(Routes.SIGN_UP);
                  },
                ),
                SB.h(MediaQuery.of(context).size.height * 0.05),
              ].map((widget) => Padding(
                padding: EdgeInsets.all(16.0),
                child: widget,
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
