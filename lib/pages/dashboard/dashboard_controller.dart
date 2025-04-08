import 'package:buddy_ai_wingman/core/constants/imports.dart';

class DashBoardController extends GetxController {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeNaveIndex(int? index) {
    if (index != null) {
      _currentIndex = index;
      update();
    }
  }
}
