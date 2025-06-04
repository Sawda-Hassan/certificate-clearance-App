import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/colors.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  Future<void> exportToCalendar(BuildContext context) async {
    final String appointmentDate = "2025-06-03";
    final String appointmentTimeStart = "10:30";
    final String appointmentTimeEnd = "11:00";
    final String location = "Admin Office Room 14";

    final dtStart = DateTime.parse(
      "\${appointmentDate}T\$appointmentTimeStart:00",
    );
    final dtEnd = DateTime.parse("\${appointmentDate}T\$appointmentTimeEnd:00");

    final icsContent =
        '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//University Clearance System//EN
BEGIN:VEVENT
SUMMARY:Certificate Collection Appointment
DTSTART:${DateFormat("yyyyMMdd'T'HHmmss").format(dtStart)}
DTEND:${DateFormat("yyyyMMdd'T'HHmmss").format(dtEnd)}
LOCATION:$location
DESCRIPTION:Please bring your University ID card and clearance documents.
END:VEVENT
END:VCALENDAR
''';

    final directory = await getTemporaryDirectory();
    final file = File('\${directory.path}/appointment.ics');
    await file.writeAsString(icsContent);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Your Appointment Calendar Event');
  }

  @override
  Widget build(BuildContext context) {
    final String appointmentDate = "June 3, 2025";
    final String appointmentTime = "10:30 AM – 11:00 AM";
    final String location = "Admin Office Room 14";
    final String instructions =
        "Please bring your University ID card and any relevant clearance documents.";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Your Appointment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Certificate Collection Schedule",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Row(
              children: const [
                Icon(Icons.calendar_today, color: AppColors.primary),
                SizedBox(width: 12),
                Text("Date:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(appointmentDate, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Row(
              children: const [
                Icon(Icons.access_time, color: AppColors.primary),
                SizedBox(width: 12),
                Text("Time:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(appointmentTime, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Row(
              children: const [
                Icon(Icons.location_on, color: AppColors.primary),
                SizedBox(width: 12),
                Text(
                  "Location:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(location, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            const Text(
              "Instructions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(instructions, style: const TextStyle(fontSize: 16)),

            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => exportToCalendar(context),
                    icon: const Icon(Icons.event),
                    label: const Text("Add to Calendar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Appointment saved.")),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Confirm Seen"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
