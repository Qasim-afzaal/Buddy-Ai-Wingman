import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:buddy_ai_wingman/core/constants/app_globals.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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

  GoogleSignInAccount? _currentUser;
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


  // Future<UserCredential?> loginWithGoogle(BuildContext context) async {
  //   try {
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       final googleAuth = await googleUser.authentication;
  //       final idToken = googleAuth.idToken;
  //       final Map<String, dynamic> payload = parseJwt(idToken!);
  //       final firstName = payload['given_name'] ?? '';
  //       final lastName = payload['family_name'] ?? '';

  //       SocialLoginModel socialLoginModel = SocialLoginModel(
  //         emailID: googleUser.email,
  //         firstName: firstName,
  //         lastName: lastName,
  //         authProvider: "GOOGLE",
  //         profile_image_url: googleUser.photoUrl ?? "",
  //       );
  //       await socialLogin(socialLoginModel);
  //       // await socialLogin(socialLoginModel);
  //       update();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Google Sign-In was cancelled by the user")),
  //       );
  //     }
  //     await GoogleSignIn().signOut();
  //   } catch (e) {
  //     print("Google Sign-In failed: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Google Sign-In failed: $e")),
  //     );
  //     return null;
  //   }
  //   return null;
  // }

  // Map<String, dynamic> parseJwt(String token) {
  //   final parts = token.split('.');
  //   if (parts.length != 3) {
  //     throw Exception('Invalid token');
  //   }
  //   final payload = parts[1];
  //   final normalized = base64Url.normalize(payload);
  //   final resp = utf8.decode(base64Url.decode(normalized));
  //   final payloadMap = json.decode(resp);
  //   if (payloadMap is! Map<String, dynamic>) {
  //     throw Exception('Invalid payload');
  //   }
  //   return payloadMap;
  // }

  // Future<void> signInWithApple(BuildContext context) async {
  //   try {
  //     final AuthorizationCredentialAppleID credential =
  //         await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final oAuthProvider = OAuthProvider("apple.com");
  //     final authCredential = oAuthProvider.credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );

  //     final userCredential = await _auth.signInWithCredential(authCredential);

  //     // Extract email and name from Apple credential (available only on first login)
  //     String email = credential.email ?? userCredential.user?.email ?? "";
  //     String firstName = credential.givenName ?? "";
  //     String lastName = credential?.familyName ?? "";

  //     // Check if the user is new and handle data accordingly
  //     bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

  //     if (isNewUser) {
  //       // Optionally update Firebase user's display name
  //       String displayName = '${firstName} ${lastName}'.trim();
  //       if (displayName.isNotEmpty) {
  //         await userCredential.user?.updateDisplayName(displayName);
  //       }
  //     } else {
  //       // For returning users, fetch stored data from your backend or Firebase
  //       // Example: Split display name if not stored separately
  //       String storedName = userCredential.user?.displayName ?? "";
  //       List<String> names = storedName.split(" ");
  //       firstName = names.isNotEmpty ? names.first : "";
  //       lastName = names.length > 1 ? names.sublist(1).join(" ") : "";
  //     }

  //     SocialLoginModel socialLoginModel = SocialLoginModel(
  //       emailID: email,
  //       firstName: firstName,
  //       lastName: lastName,
  //       authProvider: "APPLE",
  //       profile_image_url: "", // Apple doesn't provide a profile image
  //     );

  //     await socialLogin(socialLoginModel);
  //   } catch (e) {
  //     throw "Apple Sign-In Error: $e";
  //   }
  // }
  }
