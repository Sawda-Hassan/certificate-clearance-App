import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../models/student_model.dart';

/// ✅ Controller for managing student authentication and session state.
/// Handles login, logout, session restoration, and profile fetching.
class AuthController extends GetxController {
  // 🔐 Service responsible for making auth-related API calls
  final AuthService _authService = AuthService();

  // 💾 Local storage for persisting session data (token, IDs)
  final box = GetStorage();

  /// Stores the currently logged-in student data reactively
  Rxn<StudentModel> loggedInStudent = Rxn<StudentModel>();

  /// Stores the authentication token (JWT)
  RxString token = ''.obs;

  /// Get current student's ID (or empty if not logged in)
  String get studentId => loggedInStudent.value?.studentId ?? '';

  /// Get current authentication token
  String get authToken => token.value;

  /// 🔑 Attempts to log in using the provided student ID and password.
  /// On success, stores token and student info in memory and GetStorage.
  Future<bool> login(String studentId, String password) async {
    final result = await _authService.login(studentId, password);

    if (result['success']) {
      // Parse and store student data
      final student = StudentModel.fromJson(result['student']);
      loggedInStudent.value = student;
      token.value = result['token'];

      // Save session data locally
      box.write('token', result['token']);
      box.write('studentId', student.studentId);
      box.write('id', student.id);

      // Fetch full profile and update locally
      await fetchProfile();

      return true;
    }

    // Login failed
    return false;
  }

  /// 🗃️ Loads token and studentId from local storage and restores session.
  Future<void> loadFromStorage() async {
    final storedToken = box.read('token');
    final storedStudentId = box.read('studentId');

    // If valid session exists, restore it and fetch profile
    if (storedToken != null && storedStudentId != null) {
      token.value = storedToken;
      await fetchProfile();
    }
  }

  /// 📡 Fetches the student profile from the backend using the token.
  /// Updates the local reactive `loggedInStudent` value and saves `id` to storage.
  Future<void> fetchProfile() async {
    try {
      final result = await _authService.getProfile(token.value);

      if (result != null) {
        final student = StudentModel.fromJson(result);
        loggedInStudent.value = student;
        box.write('id', student.id); // Save ID again to be safe
      }
    } catch (e) {
      // TODO: You can log error with logger here if needed
    }
  }

  /// 🚪 Logs out the current user by clearing all stored session data.
  void logout() {
    token.value = '';
    loggedInStudent.value = null;
    box.remove('token');
    box.remove('studentId');
    box.remove('id');
  }
}
