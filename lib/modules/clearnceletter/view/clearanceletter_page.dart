import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../controller/clearanceletter_controller.dart';

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

        if (data == null) {
          return const Center(child: Text('No clearance data found.'));
        }

        final student = data.student;
        final appointment = data.appointment;

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
                    Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('Student ID: ${student.studentId}'),
                    Text('Faculty: ${student.faculty}'),
                    Text('Program: ${student.program}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(height: 24),
                    Text('Dear ${student.name},', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      'This is to confirm that you have successfully completed all clearance steps required by the university. You are now eligible to collect your graduation certificate.',
                    ),
                    const SizedBox(height: 16),
                    const Text('Appointment Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(children: [const Icon(Icons.calendar_month_outlined), const SizedBox(width: 8), Text(appointment.dateFormatted)]),
                    const SizedBox(height: 6),
                    Row(children: [const Icon(Icons.access_time_outlined), const SizedBox(width: 8), Text(appointment.timeRange)]),
                    const SizedBox(height: 6),
                    Row(children: [const Icon(Icons.location_on_outlined), const SizedBox(width: 8), Text(appointment.location)]),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final pdf = pw.Document();
                    pdf.addPage(
                      pw.Page(
                        build: (pw.Context context) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(24),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Clearance Letter', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 16),
                                pw.Text('Name: ${student.name}'),
                                pw.Text('Student ID: ${student.studentId}'),
                                pw.Text('Faculty: ${student.faculty}'),
                                pw.Text('Program: ${student.program}'),
                                pw.SizedBox(height: 24),
                                pw.Text('Dear ${student.name},'),
                                pw.SizedBox(height: 8),
                                pw.Text('This letter confirms that you have completed all the necessary clearance steps and are eligible to collect your graduation certificate.'),
                                pw.SizedBox(height: 24),
                                pw.Text('Appointment Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.Text('Date: ${appointment.dateFormatted}'),
                                pw.Text('Time: ${appointment.timeRange}'),
                                pw.Text('Location: ${appointment.location}'),
                                pw.SizedBox(height: 40),
                                pw.Text(appointment.location, style: pw.TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                    await Printing.layoutPdf(onLayout: (format) => pdf.save());
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text('Download PDF', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2647),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
