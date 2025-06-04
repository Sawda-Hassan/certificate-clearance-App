import 'package:flutter/material.dart';
import '../../auth/models/student_model.dart';

class WelcomeController extends ChangeNotifier {
  late StudentModel student;

  void setStudent(StudentModel data) {
    student = data;
    notifyListeners();
  }
}
