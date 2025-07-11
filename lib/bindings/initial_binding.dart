// lib/bindings/initial_binding.dart
import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/welcomeScreen/controllers/welcome_controller.dart';
import '../providers/notification_provider.dart';
import '../modules/chatbot/chatbot_badge_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationProvider());
    Get.put(AuthController());
    Get.put(WelcomeController());
    Get.put(ChatbotBadgeController()); // ✅ Register the badge controller here

    // Add any other global services/controllers here
  }
}
