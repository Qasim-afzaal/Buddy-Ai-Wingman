import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buddy_ai_wingman/core/constants/app_globals.dart';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/app_strings.dart';
import 'package:buddy_ai_wingman/core/constants/constants.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_controller.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../main.dart';
import '../../../models/error_response.dart';

class SignupController extends GetxController {
  RxString otp = "".obs;
  //  final _auth = FirebaseAuth.instance;
  TextEditingController userNameController = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final PaymentPlanController _paymentPlanController =
      getPaymentPlanController();
  RxBool areFieldsFilled = false.obs;
  LoginResponse? mainModel;

  void _checkFields() {
    areFieldsFilled.value = userNameController.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  bool showSocialLogin = false;

  void toggleLogin() {
    showSocialLogin = !showSocialLogin;
    update();
  }

  void handleNavigation() {
    // print("i am here");
    _paymentPlanController.isUserSubscribedToProduct((p0) {
      print("${emailController.text} payment for signup calling");
      Map chatmsg = {
        "name": "${emailController.text} payment for signup calling"
      };
      Constants.socket!.emit("logEvent", chatmsg);
      if (p0 == true) {
        Map chatmsg = {
          "name":
              "${emailController.text} payment verification done ....... DashBoard"
        };

        print("i am in dahsboatd");
        Get.offNamed(Routes.DASHBOARD);

        Constants.socket!.emit("logEvent", chatmsg);
      } else {
        Map chatmsg = {
          "name":
              " ${emailController.text} payment verification done ....... PayWall"
        };
        Constants.socket!.emit("logEvent", chatmsg);
        Get.offNamed(Routes.PAYMENT_PLAN);
      }
    });
  }

  @override
  void onInit() {
    userNameController.addListener(_checkFields);
    lastName.addListener(_checkFields);
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);

    super.onInit();
  }

  // void onLogin() {
  //   Get.offNamed(Routes.LOGIN);
  // }

  Future<void> onSignup() async {
    if (isSignUpValidation()) {
      var json = {
        HttpUtil.firstName: userNameController.text.trim(),
        HttpUtil.lastName: lastName.text.trim(),
        HttpUtil.authProvider: "",
        HttpUtil.email: emailController.text.trim(),
        HttpUtil.password: passwordController.text.trim(),
        HttpUtil.profileImageUrl: "",
      };
      final data = await APIFunction().apiCall(
        apiName: "users/create-user",
        // apiName: Constants.signUp,
        withOutFormData: jsonEncode(json),
      );

      try {
        mainModel = LoginResponse.fromJson(data);

        if (mainModel!.success!) {
          getStorageData.saveLoginData(mainModel!);
          handleNavigation();
        } else {
          // if (mainModel!.data!.isProfileComplete == false) {
          //   getStorageData.saveLoginData(mainModel!);
          //   handleNavigation();
          // } else {
          utils.showToast(message: mainModel!.message!);
          // }
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);

        utils.showToast(message: errorModel.message!);
      }
    }
  }

  Future<void> emailVerification() async {
    if (isEmailValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.sendOTPforEmail,
        withOutFormData: jsonEncode(json),
      );

      try {
        mainModel = LoginResponse.fromJson(data);
        if (mainModel!.success!) {
          print(
              "this is data is ${userNameController.text.trim()}..${emailController.text.trim()}..${passwordController.text.trim()}..${lastName.text.trim()}");
          Get.offNamed(Routes.OTP_SIGNIN, arguments: {
            HttpUtil.firstName: userNameController.text.trim(),
            HttpUtil.authProvider: "",
            HttpUtil.email: emailController.text.trim(),
            HttpUtil.password: passwordController.text.trim(),
            HttpUtil.lastName: lastName.text.trim(),
            HttpUtil.profileImageUrl: "",
          });
        } else {
          utils.showToast(message: mainModel!.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);

        utils.showToast(message: errorModel.message!);
      }
    }
  }

  bool isEmailValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    }
    return true;
  }

  bool isSignUpValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(userNameController.text)) {
      utils.showToast(message: AppStrings.errorUsername);
      return false;
    } else if (utils.isValidationEmpty(lastName.text)) {
      utils.showToast(message: AppStrings.errorEmptyPassword);
      return false;
    } else if (utils.isValidationEmpty(emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    } else if (utils.isValidationEmpty(passwordController.text)) {
      utils.showToast(message: AppStrings.errorEmptyPassword);
      return false;
    }
    return true;
  }

  RxString appleId = "".obs;
  RxString userName = "".obs;
  RxString userEmail = "".obs;
  final GoogleSignIn? googleSignIn = GoogleSignIn();

  Future<void> socialLogin(SocialLoginModel socialLoginModel) async {
    var json = {
      HttpUtil.email: socialLoginModel.emailID,
      HttpUtil.password: "",
      HttpUtil.authProvider: socialLoginModel.authProvider,
    };

    AppGlobals.email = HttpUtil.email;
    print("i am here${socialLoginModel.emailID} lOGIN x.....");
    Map socialMsg = {"name": " Social login in Processing"};

    Constants.socket!.emit("logEvent", socialMsg);
    final data = await APIFunction().apiCall(
      apiName: Constants.login,
      withOutFormData: jsonEncode(json),
    );
    Map msg = {"name": "${socialLoginModel.emailID} Social Login Api called"};
    Constants.socket!.emit("logEvent", msg);
    try {
      mainModel = LoginResponse.fromJson(data);
      Map msg = {
        "name":
            "${socialLoginModel.emailID} Social Login User data store in DTO Model"
      };
      Constants.socket!.emit("logEvent", msg);
      if (mainModel!.success!) {
        getStorageData.saveLoginData(mainModel!);
        // emailController.text = socialLoginModel.emailID ?? "";
        handleNavigation();
      } else {
        // utils.showToast(message: mainModel.message!);
        if (HttpUtil.authProvider != "") {
          Get.toNamed(Routes.SOCIAL, arguments: {
            HttpUtil.firstName: socialLoginModel.firstName,
            HttpUtil.authProvider: socialLoginModel.authProvider,
            HttpUtil.email: socialLoginModel.emailID,
            HttpUtil.password: "",
            HttpUtil.lastName: socialLoginModel.firstName,
            HttpUtil.profileImageUrl: "",
          });
        }
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      Map msg = {"name": "Socail Login Api Error::::${errorModel.message}"};
      Constants.socket!.emit("logEvent", msg);
      utils.showToast(message: errorModel.message!);
    }
  }
}
