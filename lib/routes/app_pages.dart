
import 'package:get/get.dart';

import '../modules/home/views/home_screen.dart';
import '../modules/home/views/onboarding_screen.dart';
import '../modules/home/views/status_screen.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/welcomeScreen/views/studentwelcomescreen.dart';
import '../modules/notifications/views/notification_screen.dart';
import '../modules/clearance/veiws/groupclearancestatusscreen.dart';
import '../modules/clearance/veiws/individual_clearance_screen.dart';
import '../modules/name_correction/views/name_correction_screen.dart';
import '../modules/appointments/views/appointment_screen.dart';
import '../modules/libraryclearance/view/library_clearance_page.dart'; // Or your real path!
import '../modules/labclearance/view/lab_clearance_page.dart';
import '../modules/finance/view/finance_clearance_page.dart';
import '../modules/Evcpayment/views/paymentscreen.dart';





import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),

    // ✅ FIXED: StudentWelcomeScreen now receives both required parameters
    GetPage(
      name: AppRoutes.welcome,
      page: () => StudentWelcomeScreen(
        studentName: 'Student',
        gender: 'male',
      ),
    ),

    GetPage(name: AppRoutes.status, page: () => const status_screen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.notification, page: () => const NotificationScreen()),
    GetPage(name: AppRoutes.clearanceStatus, page: () => const groupclearancestatusscreen()),
    GetPage(name: AppRoutes.individualClearance, page: () => const IndividualClearanceScreen()),
    GetPage(name: AppRoutes.nameCorrection, page: () => const NameCorrectionScreen()),
    GetPage(name: AppRoutes.appointment, page: () => const AppointmentScreen()),
    GetPage(name: AppRoutes.libraryClearance, page: () =>  LibraryClearancePage()), // ADD THIS
    GetPage(name: AppRoutes.LabClearancePage,page: () => LabClearancePage()),
     GetPage(
  name: '/finance-clearance',
  page: () => FinanceClearancePage(),
),

GetPage(
  name: AppRoutes.financePayment,
  page: () => const Paymentscreen(), // ✅ Match class name exactly
),

  


  ];
}
