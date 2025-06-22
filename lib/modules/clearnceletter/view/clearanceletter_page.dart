import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/clearanceletter_controller.dart';
import '../../../widgets/pdf_download_button.dart';

class ClearanceLetterPage extends StatelessWidget {
  const ClearanceLetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClearanceLetterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('CLEARANCE LETTER'),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.clearanceData;

        if (data == null || data.student == null || data.appointment == null) {
          return const Center(child: Text('No clearance data found.'));
        }

        final student = data.student!;
        final appointment = data.appointment!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name ?? 'No Name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Student ID: ${student.studentId ?? "N/A"}'),
                    Text('Faculty: ${student.faculty ?? "N/A"}'),
                    Text('Program: ${student.program ?? "N/A"}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(height: 24),
                    Text('Dear ${student.name ?? "Student"},',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      'This is to confirm that you have successfully completed all clearance steps required by the university. You are now eligible to collect your graduation certificate.',
                    ),
                    const SizedBox(height: 16),
                    const Text('Appointment Details:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 8),
                        Text(appointment.dateFormatted ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined),
                        const SizedBox(width: 8),
                        Text(appointment.timeRange ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 8),
                        Text(appointment.location ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const PdfDownloadButton(),
            ],
          ),
        );
      }),
    );
  }
}
