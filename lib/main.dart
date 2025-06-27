import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'constants/colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'package:clearance_app/modules/auth/controllers/auth_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final auth = Get.put(AuthController());        // ✅ Register controller
  await auth.loadFromStorage();                 // ✅ Load saved session (including student ID)

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
