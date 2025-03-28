import 'package:get/get.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../api_repository/api_class.dart';
import '../../../core/enums/genders.dart';
import '../../../core/enums/personality.dart';

class CreateAccountController extends GetxController {
  Genders? gender;
  String? ageRange;
  Personality? personalityType;
  createAccount() {
    Get.offNamed(Routes.SIGN_UP, arguments: {
      HttpUtil.gender: genderValue(gender!),
      HttpUtil.age: ageRange,
      HttpUtil.personalityType: personalityTypeValue(personalityType!),
    });
  }

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

  @override
  void onInit() {
    if (Get.arguments != null) {
      gender = Get.arguments[HttpUtil.gender];
      ageRange = Get.arguments[HttpUtil.age].toString();
      personalityType = Get.arguments[HttpUtil.personalityType];
    }
    super.onInit();
  }
}
