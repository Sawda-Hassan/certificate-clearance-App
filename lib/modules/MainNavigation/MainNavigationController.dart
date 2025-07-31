// controllers/main_navigation_controller.dart
import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void switchTab(int index) {
    currentIndex.value = index;
  }
}
