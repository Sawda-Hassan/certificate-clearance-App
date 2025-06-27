import 'package:get/get.dart';
import '../model/appointment_model.dart';
import '../service/appointment_service.dart';

class AppointmentController extends GetxController {
  var appointment = Rxn<AppointmentModel>();
  var isLoading = false.obs;

  Future<void> loadAppointment(String studentId) async {
    //print("📦 Loading appointment for: $studentId");
    isLoading.value = true;

    final data = await AppointmentService.fetchAppointmentByStudent(studentId);
    appointment.value = data;

    if (data != null) {
     // print("✅ Appointment loaded: ${data.id}");
    } else {
      //print("⚠️ No appointment returned.");
    }

    isLoading.value = false;
  }

  Future<void> checkIn(String studentId) async {
    final success = await AppointmentService.checkIn(studentId);
    if (success) {
      await loadAppointment(studentId); // Refresh
    }
  }

  Future<void> reschedule(String studentId, String newDate, String reason) async {
    final success = await AppointmentService.reschedule(studentId, newDate, reason);
    if (success) {
      await loadAppointment(studentId); // Refresh
    }
  }
}
