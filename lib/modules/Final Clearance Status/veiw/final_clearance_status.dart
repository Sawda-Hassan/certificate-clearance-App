import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/clearance_controller.dart';

class FinalClearanceStatus extends StatelessWidget {
  final String studentId;
  FinalClearanceStatus({super.key, required this.studentId});

  final ctrl = Get.put(ClearanceController());

  @override
  Widget build(BuildContext context) {
    ctrl.loadClearance(studentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Clearance Status"),
        backgroundColor: const Color(0xFF0A2647),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.steps.length,
                itemBuilder: (context, index) {
                  final step = ctrl.steps[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green.shade100),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: step.status == 'Approved' ? Colors.green : Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.title,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Status: ${step.status}"),
                              if (step.clearedOn != null)
                                Text(
                                  "Cleared on: ${DateFormat.yMMMd().format(step.clearedOn!)}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '"You have completed 100% of your certificate clearance."',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Hook to clearance letter download
                },
                icon: const Icon(Icons.download),
                label: const Text("Download Clearance Letter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2647),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
