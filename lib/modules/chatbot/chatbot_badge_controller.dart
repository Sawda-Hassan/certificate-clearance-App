import 'package:get/get.dart';

class ChatbotBadgeController extends GetxController {
  var unreadCount = 0.obs;

  void increment() => unreadCount.value++;
  void clear() => unreadCount.value = 0;
}
