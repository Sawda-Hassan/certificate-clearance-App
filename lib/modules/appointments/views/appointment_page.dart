import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/appointment_controller.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_routes.dart';

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF28A745);

class AppointmentPage extends StatelessWidget {
  final ctrl = Get.put(AppointmentController());
  final auth = Get.find<AuthController>();

  AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentId = auth.loggedInStudent.value?.id ?? '';

    // Load appointment on build
    ctrl.loadAppointment(studentId);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointment = ctrl.appointment.value;

          if (appointment == null) {
            return const Center(child: Text("No appointment found."));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Your Appointment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: _green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(Icons.check_circle, size: 48, color: _green),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Your certificate request\nhas been received',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _AppointmentDetailRow(
                        icon: Icons.calendar_today,
                        text: DateFormat.yMMMMd().format(appointment.appointmentDate),
                      ),
                      const SizedBox(height: 12),
                      _AppointmentDetailRow(
                        icon: Icons.access_time,
                        text: DateFormat.jm().format(appointment.appointmentDate),
                      ),
                      const SizedBox(height: 12),
                      const _AppointmentDetailRow(
                        icon: Icons.location_on,
                        text: 'Examination Office #A1',
                      ),
                      const SizedBox(height: 12),
                      _AppointmentDetailRow(
                        icon: Icons.verified,
                        text: appointment.status.capitalizeFirst ?? 'Pending',
                        color: _green,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                        onPressed: () async {
      await ctrl.checkIn(studentId); // confirm appointment (no need to pass data)
      Get.toNamed(AppRoutes.clearanceLetter); // safer

    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _AppointmentDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _AppointmentDetailRow({
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.black87),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
