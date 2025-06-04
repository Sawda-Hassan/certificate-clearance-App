// lib/bindings/initial_binding.dart
import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/welcomeScreen/controllers/welcome_controller.dart';
import '../providers/notification_provider.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationProvider());
    Get.put(AuthController());
    Get.put(WelcomeController());
    // Add any other global services/controllers here
  }
}
