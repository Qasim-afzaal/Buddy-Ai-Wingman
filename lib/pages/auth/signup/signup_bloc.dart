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

import '../../../routes/app_pages.dart';

class SignupBlocPage extends StatefulWidget {
  const SignupBlocPage({super.key});

  @override
  State<SignupBlocPage> createState() => _SignupBlocPageState();
}

class _SignupBlocPageState extends State<SignupBlocPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isSignUpValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(_userNameController.text)) {
      utils.showToast(message: AppStrings.errorUsername);
      return false;
    } else if (utils.isValidationEmpty(_emailController.text)) {
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
          child: Form(
            key: _formKey,
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
                              "Register into \nBuddy Ai Wingman",
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
                  SB.h(25),
                  CustomTextField(
                    controller: _userNameController,
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                      } else if (state is AuthEmailVerificationSent) {
                        Get.offNamed(Routes.OTP_SIGNIN, arguments: {
                          'firstName': _userNameController.text.trim(),
                          'authProvider': "",
                          'email': _emailController.text.trim(),
                          'password': _passwordController.text.trim(),
                          'lastName': _userNameController.text.trim(),
                          'profileImageUrl': "",
                        });
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        buttonText: "Sign Up",
                        onTap: state is AuthLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_isSignUpValidation()) {
                              context.read<AuthBloc>().add(
                                AuthSignupRequested(
                                  firstName: _userNameController.text,
                                  lastName: _userNameController.text, // Using same as firstName for now
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Already have an account?",
                      style: headingTextStyle(decoration: TextDecoration.underline),
                    ),
                    onPressed: () {
                      Get.offNamed(Routes.LOGIN);
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
      ),
    );
  }
}
