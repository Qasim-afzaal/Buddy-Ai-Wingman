import 'package:buddy/core/constants/imports.dart';

class DashBoardController extends GetxController {
  int _currentIndex = 0;
  static const int minIndex = 0;
  static const int maxIndex = 3; // Based on 4 tabs in dashboard

  int get currentIndex => _currentIndex;

  /// Changes the navigation index with validation
  /// 
  /// [index] must be non-null and within valid range [minIndex, maxIndex]
  void changeNavIndex(int? index) {
    if (index == null) {
      return;
    }
    
    // Validate index is within bounds
    if (index < minIndex || index > maxIndex) {
      debugPrint('⚠️ Invalid navigation index: $index. Valid range: $minIndex-$maxIndex');
      return;
    }
    
    if (_currentIndex != index) {
      _currentIndex = index;
      update();
    }
  }
}
