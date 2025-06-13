import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final box = GetStorage(); // ✅ Storage for token + studentId
  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();
  RxString token = ''.obs;

  /// Login student using ID and password
  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      final student = StudentModel.fromJson(result['student']);
      loggedInStudent.value = student;
      token.value = result['token'];

      // ✅ Save both token and studentId to device storage
      box.write('token', result['token']);
      box.write('studentId', student.studentId); // 👈 Important for finance status

      print('✅ Logged in student JWT: ${result['token']}');
      print('📦 Stored studentId: ${student.studentId}');

      return true;
    }

    print('❌ Login failed: ${result['message'] ?? 'Unknown error'}');
    return false;
  }

  /// Get current token
  String get authToken => token.value;

  /// Logout and clear session
  void logout() {
    token.value = '';
    loggedInStudent.value = null;
    box.remove('token');
    box.remove('studentId'); // 👈 Also clear student ID
    print('👋 Logged out and cleared storage');
  }
}
