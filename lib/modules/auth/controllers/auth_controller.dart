import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();

  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();
  RxString token = ''.obs;

  String get studentId => loggedInStudent.value?.studentId ?? '';
  String get authToken => token.value;

  /// 🔐 Login and handle full flow
  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      final student = StudentModel.fromJson(result['student']);
      loggedInStudent.value = student;
      token.value = result['token'];

      box.write('token', result['token']);
      box.write('studentId', student.studentId);
      box.write('id', student.id);

      // 📡 Fetch full profile first
      await fetchProfile();

      // ✅ Then save FCM token using stored JWT
      await _authService.sendFcmTokenToBackend(token.value);

      return true;
    }

    return false;
  }

  /// Load session from local storage
  Future<void> loadFromStorage() async {
    final storedToken = box.read('token');
    final storedStudentId = box.read('studentId');

    if (storedToken != null && storedStudentId != null) {
      token.value = storedToken;
      await fetchProfile();
    }
  }

  /// Fetch profile and update student model
  Future<void> fetchProfile() async {
    try {
      final result = await _authService.getProfile(token.value);
      if (result != null) {
        final student = StudentModel.fromJson(result);
        loggedInStudent.value = student;
        box.write('id', student.id);
      }
    } catch (e) {
      print('❌ Profile fetch failed: $e');
    }
  }

  /// Logout and clear storage
  void logout() {
    token.value = '';
    loggedInStudent.value = null;
    box.remove('token');
    box.remove('studentId');
    box.remove('id');
  }
}
