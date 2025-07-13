import 'package:get/get.dart';

// Screens
import '../modules/home/views/home_screen.dart';
import '../modules/home/views/onboarding_screen.dart';
import '../modules/home/views/status_screen.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/welcomeScreen/views/studentwelcomescreen.dart';
import '../modules/libraryclearance/view/library_clearance_page.dart';
import '../modules/labclearance/view/lab_clearance_page.dart';
import '../modules/finance/view/finance_clearance_page.dart';
import '../modules/Evcpayment/views/paymentscreen.dart';
import '../modules/Examination/view/ExaminationClearancePage.dart';
import '../modules/name_correction/views/name_correction_screen.dart';
import '../modules/upload/veiw/nameupload_page.dart';
import '../modules/appointments/views/appointment_page.dart';
import '../modules/clearnceletter/view/clearanceletter_page.dart';
import '../modules/name_correction_not_allowed/veiw/name_correction_not_allowed.dart';
import '../modules/chatbot/chatbot_screen.dart';






import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),

    // ✅ Student Welcome Screen
    GetPage(
      name: AppRoutes.welcome,
      page: () => const StudentWelcomeScreen(
        studentName: 'Student',
        gender: 'male',
      ),
    ),

    GetPage(name: AppRoutes.status, page: () => const status_screen()),
    GetPage(name: AppRoutes.profile, page: () =>  ProfileScreen()),

    GetPage(name: AppRoutes.libraryClearance, page: () => LibraryClearancePage()),
    GetPage(name: AppRoutes.LabClearancePage, page: () => LabClearancePage()),
    GetPage(name: AppRoutes.financeClearance, page: () => FinanceClearancePage()),
    GetPage(name: AppRoutes.financePayment, page: () => const Paymentscreen()),
    GetPage(name: AppRoutes.examClearance,page: () => ExaminationClearancePage(),
),
     GetPage(
      name: AppRoutes.nameCorrection,
      page: () => const NameVerificationPage(),
    ),
  



GetPage(
  name: AppRoutes.nameUpload, // ✅ use the constant
  page: () => const NameUploadPage(),
),
GetPage(
  name: AppRoutes.appointment,
  page: () => AppointmentPage(),
),
GetPage(
  name: AppRoutes.clearanceLetter,
  page: () => ClearanceLetterPage(),
),

 GetPage(
    name: AppRoutes.nameCorrectionNotAllowed,
    page: () => const NameCorrectionNotAllowedPage(),
  ),
     GetPage(
  name: AppRoutes.studentWelcome,
  page: () => const StudentWelcomeScreen(
    studentName: 'Student',
    gender: 'male',
  ),
),
GetPage(
  name: AppRoutes.chatbot,
  page: () => ChatbotScreen(),
),


  ];
  
  
  
}
