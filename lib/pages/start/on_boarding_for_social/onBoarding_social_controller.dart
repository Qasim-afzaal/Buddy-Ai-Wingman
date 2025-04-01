import 'dart:convert';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/models/error_response.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login_response.dart';

import '../../../routes/app_pages.dart';

class OnBoardingSocialController extends GetxController {
  Genders? selectedGender;
  String? selectedAgeRange;
  Personality? selectedPersonality;
  RxInt currentPage = 0.obs;
  String? gender;
  String? ageRange;
  String? personalityType;
   String? name;
  String? email;
  String? authprovider;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final PageController pageController = PageController();
//  final PaymentPlanController _paymentPlanController =
//       getPaymentPlanController();
  void onGenderSelection(Genders gender) {
    selectedGender = gender;
    update();
    _nextPage();
  }
  //   void handleNavigation() {
  //   _paymentPlanController.isUserSubscribedToProduct((p0) {
  //     if (p0 == true) {
  //       Get.offNamed(Routes.DASHBOARD);
  //     } else {
  //       Get.offNamed(Routes.PAYMENT_PLAN);
  //     }
  //   });
  // }
String genderValue(Genders gender) {
    switch (gender) {
      case Genders.Male:
        return "Male";
      case Genders.Female:
        return "Female";
      case Genders.Other:
        return "Other";
    }
  }

  String personalityTypeValue(Personality personalityType) {
    switch (personalityType) {
      case Personality.Seductive:
        return "Seductive";
      case Personality.Extrovert:
        return "Extrovert";
      case Personality.Introvert:
        return "Introvert";
      case Personality.Romantic:
        return "Romantic";
    }
  }

  void onAgeSelection(String age) {
    selectedAgeRange = age;

    update();
    _nextPage();
  }

  void onPersonalitySelection(Personality personality) {
    selectedPersonality = personality;
    update();
  }

  void _nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void onFinish() {
    Get.offNamed(Routes.CREATE_ACCOUNT, arguments: {
      HttpUtil.gender: selectedGender,
      HttpUtil.age: selectedAgeRange,
      HttpUtil.personalityType: selectedPersonality,
    });
  }

  Future<void> onSignup() async {
    var json = {
      HttpUtil.name:name,
      HttpUtil.authProvider: authprovider,
      HttpUtil.email: email,
      HttpUtil.password: passwordController.text.trim(),
      HttpUtil.gender: genderValue(selectedGender!),
      HttpUtil.age: selectedAgeRange,
      HttpUtil.personalityType:  personalityTypeValue(selectedPersonality!),
      HttpUtil.profileImageUrl: "",
    };
    print(json);
    final data = await APIFunction().apiCall(
      apiName: Constants.signUp,
      withOutFormData: jsonEncode(json),
    );
    try {
      LoginResponse mainModel = LoginResponse.fromJson(data);
      if (mainModel.success!) {
        getStorageData.saveLoginData(mainModel);
      // handleNavigation();
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }

  void onLogin() {
    Get.offNamed(Routes.LOGIN);
  }
    @override
  void onInit() {
    if (Get.arguments != null) {
      name = Get.arguments[HttpUtil.name];
      email = Get.arguments[HttpUtil.email].toString();
      authprovider = Get.arguments[HttpUtil.authProvider];
    }
    super.onInit();
  }
}
