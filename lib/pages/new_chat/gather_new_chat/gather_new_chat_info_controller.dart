import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/home_controller.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/spark_line_response.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/with_file_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../core/constants/helper.dart';
import '../../../models/error_response.dart';

class GatherNewChatInfoController extends GetxController {
  Genders? selectedGender;
  String? selectedAgeRange, selectedObjective;
  Personality? selectedPersonality;
  RxInt currentPage = 0.obs;
  final PageController pageController = PageController();
  TextEditingController nameController = TextEditingController();
  SparkLinesModel? message;
  String? filePath;
  bool isManually = false;

  @override
  void onInit() {
    // if (Get.arguments != null) {
    //   message = Get.arguments[HttpUtil.message];
    //   if (message == null) {
    //     isManually = Get.arguments[HttpUtil.isManually];
    //     if (!isManually) {
    //       filePath = Get.arguments[HttpUtil.filePath];
    //       print(" this is file path $filePath");
    //     }
    //   }
    // }
    super.onInit();
  }

  void onButtonPressed() async {
    Get.toNamed(Routes.MANUAL_CHAT,
        arguments: {HttpUtil.name: nameController.text});
  }

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

  void onObjectiveSelection(String objective) {
    selectedObjective = objective;
    update();
    _nextPage();
  }

  void onPersonalitySelection(Personality personality) {
    selectedPersonality = personality;
    update();
    _nextPage();
  }

  void _nextPage() {
    utils.hideKeyboard();
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    utils.hideKeyboard();
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  Future<void> getSparkd() async {
    if (isManually) {
      if (validate()) {
        Get.offNamed(
          Routes.CHAT,
          arguments: {
            HttpUtil.isManually: isManually,
            HttpUtil.name: nameController.text.trim(),
            HttpUtil.objective: selectedObjective,
            HttpUtil.gender: genderValue(selectedGender!),
            HttpUtil.age: selectedAgeRange,
            HttpUtil.personalityType:
                personalityTypeValue(selectedPersonality!),
          },
        );
      }
    } else {
      if (message != null) {
        var json = {
          HttpUtil.conversationId: "",
          HttpUtil.messageId: "",
          HttpUtil.message: message?.text ?? "",
          HttpUtil.name: nameController.text.trim() ?? "",
          HttpUtil.objective: selectedObjective ?? "",
          HttpUtil.gender: genderValue(selectedGender),
          HttpUtil.age: selectedAgeRange ?? "",
          HttpUtil.personalityType: personalityTypeValue(selectedPersonality),
        };
        print("this is data$json");
        final data = await APIFunction().patchApiCall(
          apiName: Constants.buddy_ai_wingmanLines,
          withOutFormData: jsonEncode(json),
        );
        try {
          SparkLineResponse mainModel = SparkLineResponse.fromJson(data);
          if (mainModel.success!) {
            Get.offNamed(
              Routes.SPARKD_LINES_RESPONSE,
              arguments: {
                HttpUtil.conversationId: mainModel.data?[0].conversationId,
                HttpUtil.message: message,
                HttpUtil.name: nameController.text.trim(),
              },
            );
            update();
          } else {
            utils.showToast(message: mainModel.message!);
          }
        } catch (e) {
          ErrorResponse errorModel = ErrorResponse.fromJson(data);
          utils.showToast(message: errorModel.message!);
        }
      } else {
        if (validate()) {
          FormData formData = FormData.fromMap({
            HttpUtil.name: nameController.text.trim(),
            HttpUtil.objective: selectedObjective,
            HttpUtil.gender: genderValue(selectedGender!),
            HttpUtil.age: selectedAgeRange,
            HttpUtil.personalityType:
                personalityTypeValue(selectedPersonality!),
          });
          printAction("<<<<< ImagePath >>>>> $filePath");
          if (filePath != null) {
            formData.files.add(MapEntry(
                HttpUtil.profileImageUrl,
                MultipartFile.fromFileSync(
                  filePath!,
                  filename: filePath!.split("/").last,
                )));
          }

          final data = await APIFunction().patchApiCall(
            apiName: Constants.withFile,
            data: formData,
          );
          try {
            WithFileResponse mainModel = WithFileResponse.fromJson(data);
            if (mainModel.success!) {
              Get.offNamed(
                Routes.CHAT,
                arguments: {
                  HttpUtil.conversationId: mainModel.data![0].conversationId,
                  HttpUtil.name: nameController.text.trim(),
                  HttpUtil.isManually: isManually,
                },
              );
            } else {
              utils.showToast(message: mainModel.message!);
            }
          } catch (e) {
            ErrorResponse errorModel = ErrorResponse.fromJson(data);
            utils.showToast(message: errorModel.message!);
          }
        }
      }
    }
  }

  Future<void> handleMessage(String? message) async {
    if (message != null) {
      var json = {
        HttpUtil.conversationId: "",
        HttpUtil.messageId: "",
        HttpUtil.message: message ?? "",
        HttpUtil.name: nameController.text.trim(),
        HttpUtil.objective: selectedObjective ?? "",
        HttpUtil.gender: genderValue(selectedGender),
        HttpUtil.age: selectedAgeRange ?? "",
        HttpUtil.personalityType: personalityTypeValue(selectedPersonality),
      };

      print("this is data$json");

      final data = await APIFunction().patchApiCall(
        apiName: Constants.buddy_ai_wingmanLines,
        withOutFormData: jsonEncode(json),
      );

      try {
        SparkLineResponse mainModel = SparkLineResponse.fromJson(data);
        if (mainModel.success!) {
          Get.toNamed(
            Routes.SPARKD_LINES_RESPONSE,
            arguments: {
              HttpUtil.conversationId: mainModel.data?[0].conversationId,
              HttpUtil.message: message,
              HttpUtil.name: nameController.text.trim(),
            },
          );
          update();
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  bool validate() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(selectedObjective)) {
      pageController.jumpToPage(0);
      utils.showToast(message: AppStrings.selectedObjective);
      return false;
    } else if (selectedGender == null) {
      pageController.jumpToPage(1);
      utils.showToast(message: AppStrings.selectedGender);
      return false;
    } else if (utils.isValidationEmpty(selectedAgeRange)) {
      pageController.jumpToPage(2);
      utils.showToast(message: AppStrings.selectedAge);
      return false;
    } else if (selectedPersonality == null) {
      pageController.jumpToPage(3);
      utils.showToast(message: AppStrings.selectedPersonality);
      return false;
    } else if (utils.isValidationEmpty(nameController.text)) {
      utils.showToast(message: AppStrings.errorName);
      return false;
    }
    return true;
  }

  String genderValue(Genders? gender) {
    switch (gender) {
      case Genders.Male:
        return "Male";
      case Genders.Female:
        return "Female";
      case Genders.Other:
        return "Other";
      case null:
        return "";
    }
  }

  String personalityTypeValue(Personality? personalityType) {
    switch (personalityType) {
      case Personality.Seductive:
        return "Seductive";
      case Personality.Extrovert:
        return "Extrovert";
      case Personality.Introvert:
        return "Introvert";
      case Personality.Romantic:
        return "Romantic";
      case null:
        return "";
    }
  }
}
