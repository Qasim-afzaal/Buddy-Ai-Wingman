import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/app_globals.dart';
import 'package:buddy_ai_wingman/core/constants/app_strings.dart';
import 'package:buddy_ai_wingman/core/constants/constants.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';
import 'package:buddy_ai_wingman/pages/new_chat/chat/error_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final _auth = FirebaseAuth.instance;
  LoginResponse? mainModel;
  RxBool areFieldsFilled = false.obs;
  @override
  void onInit() {
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);

    super.onInit();
  }

  void _checkFields() {
    // Check if all fields are filled and update the RxBool
    areFieldsFilled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  void handleNavigation() {
    // print("i am here${emailController.text} Recipt Verification.....");
    // Map msg = {
    //   "name": "${emailController.text ?? ""} Recipt Verification....."
    // };
    // Constants.socket!.emit("logEvent", msg);
    // _paymentPlanController.isUserSubscribedToProduct((p0) {
    //   print("Verification Api Called Status::$p0");
    //   Map msg = {"name": " Api Called Navigate base on Status$p0 ..."};

    //   Constants.socket!.emit("logEvent", msg);
    //   if (p0 == true) {
    //     print("i am here${emailController.text} dashbord.....");
    //     Map msg = {"name": "Verification Done Navigate to Dashboad ..."};
    //     print(
    //         "i am here${emailController.text ?? ""} Recipt Verification.....");
    //     Constants.socket!.emit("logEvent", msg);

    Get.offNamed(Routes.HOME);

    //   } else {
    //     print("i am here${emailController.text} Paywalll.....");
    //     Map msg = {"name": " Verification Done Navigate to PayWall ..."};

    //     Constants.socket!.emit("logEvent", msg);
    //     Get.offNamed(Routes.PAYMENT_PLAN);
    //   }
    // });
  }

  Future<void> onLogin() async {
    if (isLoginValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
        HttpUtil.password: passwordController.text.trim(),
        HttpUtil.authProvider: "",
      };

      final data = await APIFunction().apiCall(
        apiName: "auth/sign-in",
        // apiName: Constants.login,
        withOutFormData: jsonEncode(json),
      );

      try {
        mainModel = LoginResponse.fromJson(data);
        AppGlobals.email = emailController.text;

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

  void navigateToSignup() {
    Get.offNamed(Routes.ON_BOARDING);
  }

  bool isLoginValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(emailController.text)) {
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

class SocialLoginModel {
  String? emailID;
  String? name;
  String? firstName;
  String? lastName;
  String? authProvider;
  String? profile_image_url;

  SocialLoginModel({
    this.emailID,
    this.name,
    this.firstName,
    this.lastName,
    this.authProvider,
    this.profile_image_url,
  });
}
