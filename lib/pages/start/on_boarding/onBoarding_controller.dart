import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/core/constants/imports.dart';

import '../../../routes/app_pages.dart';

class OnBoardingController extends GetxController {
  Genders? selectedGender;
  String? selectedAgeRange;
  Personality? selectedPersonality;
  RxInt currentPage = 0.obs;
  final PageController pageController = PageController();

  void onGenderSelection(Genders gender) {
    selectedGender = gender;
    update();
    _nextPage();
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

  void onLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
