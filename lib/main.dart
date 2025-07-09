import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'constants/colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

// 🔕 Notification-related imports (Commented Out)
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'firebase_options.dart';
// import 'package:clearance_app/modules/auth/controllers/auth_controller.dart';

// 🔕 Background FCM handler (Commented Out)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📩 [Background] Notification: ${message.notification?.title}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔕 Firebase initialization and FCM setup (Commented Out)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // String? token = await FirebaseMessaging.instance.getToken();
  // print('📲 FCM Token: $token');
  // NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // print('🔔 Permission status: ${settings.authorizationStatus}');
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('📩 [Foreground] Notification: ${message.notification?.title}');
  //   if (message.notification != null) {
  //     Get.snackbar(
  //       message.notification!.title ?? 'Notification',
  //       message.notification!.body ?? '',
  //       snackPosition: SnackPosition.TOP,
  //       duration: const Duration(seconds: 5),
  //       backgroundColor: Colors.black87,
  //       colorText: Colors.white,
  //     );
  //   }
  // });

  // ✅ Initialize GetStorage
  await GetStorage.init();

  // ✅ Load auth from storage (Uncomment this only if AuthController is available)
  // final auth = Get.put(AuthController());
  // await auth.loadFromStorage();

  // ✅ Start app
  runApp(const ClearanceApp());
}

class ClearanceApp extends StatelessWidget {
  const ClearanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Certificate Clearance',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: const Center(child: Text('🚫 404 - Route not found')),
        ),
      ),
    );
  }
}
