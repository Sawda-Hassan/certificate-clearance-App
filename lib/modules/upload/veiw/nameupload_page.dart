import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controlerr/nameupload_controller.dart';

class NameUploadPage extends StatelessWidget {
  const NameUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NameUploadController());
    final auth = Get.find<AuthController>();
    final studentId = auth.loggedInStudent.value?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Name Correction"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter the name you wish to appear on your certificate:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFF8F8F8),
                  ),
                  child: InkWell(
                    onTap: () => _showNameDialog(context, ctrl),
                    child: Text(
                      ctrl.requestedName.value.isEmpty
                          ? "Tap to enter name"
                          : ctrl.requestedName.value,
                      style: TextStyle(
                        color: ctrl.requestedName.value.isEmpty ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text("📎 Upload document to verify this name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                const Text(
                  "High school certificate, passport, Birth certificate",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: ctrl.pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Upload File"),
                ),

                if (ctrl.selectedFileName.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("📄 ${ctrl.selectedFileName.value}"),
                  ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Checkbox(
                      value: ctrl.isConfirmed.value,
                      onChanged: (val) => ctrl.isConfirmed.value = val ?? false,
                    ),
                    const Expanded(
                      child: Text(
                        "I confirm that the name provided is accurate and matches my official documents",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                LinearProgressIndicator(value: 1.0, color: Colors.blue),
                const SizedBox(height: 6),
                const Text("100% completed", style: TextStyle(fontSize: 13)),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.isFormValid ? () => ctrl.submit(studentId) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: ctrl.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Confirm", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showNameDialog(BuildContext context, NameUploadController ctrl) {
    final nameCtrl = TextEditingController(text: ctrl.requestedName.value);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Correct Name"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: "e.g. Adan Nour Hassan"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ctrl.requestedName.value = nameCtrl.text.trim();
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
