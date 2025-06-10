import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Add this line:
  final box = GetStorage();

  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();
  RxString token = ''.obs;

  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      loggedInStudent.value = StudentModel.fromJson(result['student']);
      token.value = result['token'];

      // 👇 Save token to device storage
      box.write('token', result['token']);

      print('✅ Logged in student JWT: ${result['token']}');
      return true;
    }

    return false;
  }

  String get authToken => token.value;

  // Add logout for good measure!
  void logout() {
    token.value = '';
    loggedInStudent.value = null;
    box.remove('token'); // 👈 Remove token from device storage
  }
}
