import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();
  RxString token = ''.obs;

  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      loggedInStudent.value = StudentModel.fromJson(result['student']);
      token.value = result['token']; // ✅ make sure this line is here
      return true;
    }

    return false;
  }

  String get authToken => token.value;
}
