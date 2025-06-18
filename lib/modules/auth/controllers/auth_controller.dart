// 📁 lib/controller/auth_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();

  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();
  RxString token = ''.obs;

  /// ✅ Get student ID
  String get studentId => loggedInStudent.value?.studentId ?? '';

  /// ✅ Get auth token
  String get authToken => token.value;

  /// ✅ Login logic
  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      final student = StudentModel.fromJson(result['student']);
      loggedInStudent.value = student;
      token.value = result['token'];

      box.write('token', result['token']);
      box.write('studentId', student.studentId);

      print('✅ Logged in student JWT: ${result['token']}');
      print('📦 Stored studentId: ${student.studentId}');

      return true;
    }

    print('❌ Login failed: ${result['message'] ?? 'Unknown error'}');
    return false;
  }

  /// ✅ Load session
  void loadFromStorage() {
    final storedToken = box.read('token');
    final storedStudentId = box.read('studentId');

    if (storedToken != null && storedStudentId != null) {
      token.value = storedToken;
      loggedInStudent.value = StudentModel(
        studentId: storedStudentId,
        fullName: 'Unknown',
        gender: 'Unknown',
      );
      print('📦 Loaded session from storage');
    }
  }

  /// ✅ Logout
  void logout() {
    token.value = '';
    loggedInStudent.value = null;
    box.remove('token');
    box.remove('studentId');
    print('👋 Logged out and cleared session');
  }
}
