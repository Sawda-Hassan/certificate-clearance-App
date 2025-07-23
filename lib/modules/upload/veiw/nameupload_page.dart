import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controlerr/nameupload_controller.dart';
import '../../../widgets/curved_app_bar.dart';
import '../../../routes/app_routes.dart'; // ensure this is imported

const _navy = Color(0xFF0A2647);

class NameUploadPage extends StatelessWidget {
  const NameUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NameUploadController());
    final auth = Get.find<AuthController>();

    final studentId = auth.loggedInStudent.value?.studentId ?? '';
    final currentName = auth.loggedInStudent.value?.fullName ?? '';
    ctrl.currentName.value = currentName;

    final RxBool triedSubmit = false.obs;

    return Scaffold(
      appBar: const CurvedAppBar(title: "Name Correction"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your name you wish to appear on your certificate:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: ctrl.requestedName.value.isNotEmpty
                        ? ctrl.requestedName.value
                        : currentName,
                    onChanged: (value) =>
                        ctrl.requestedName.value = value.trim(),
                    decoration: InputDecoration(
                      hintText: "Tap to enter name",
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: triedSubmit.value &&
                              (ctrl.requestedName.value.trim().isEmpty ||
                                  ctrl.requestedName.value.trim() ==
                                      ctrl.currentName.value.trim())
                          ? 'Please enter a new name different from your current name'
                          : null,
                    ),
                    style: const TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 38),
                  const Text(
                    "📎 Upload document to verify this name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "High school certificate, passport, Birth certificate",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: ctrl.pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Upload File",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  if (ctrl.selectedFileName.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("📄 ${ctrl.selectedFileName.value}"),
                    )
                  else if (triedSubmit.value)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "❗ You must upload a document",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  else
                    const SizedBox(height: 8),
                  const SizedBox(height: 42),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: ctrl.isConfirmed.value,
                        activeColor: _navy,
                        onChanged: (val) =>
                            ctrl.isConfirmed.value = val ?? false,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          "I confirm that the name provided is accurate and matches my official documents",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  if (triedSubmit.value && !ctrl.isConfirmed.value)
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        "❗ You must confirm the declaration",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (ctrl.isLoading.value)
                    const LinearProgressIndicator(
                      color: _navy,
                      minHeight: 6,
                    )
                  else
                    const SizedBox(height: 6),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        triedSubmit.value = true;

                        final name = ctrl.requestedName.value.trim();
                        final file = ctrl.selectedFile.value;
                        final confirmed = ctrl.isConfirmed.value;

                        final nameValid = name.isNotEmpty &&
                            name != ctrl.currentName.value.trim();
                        final fileValid = file != null;

                        if (nameValid && fileValid && confirmed) {
                          await ctrl.submit(studentId);

                          // ✅ Show success card and go to Home
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 32),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Upload Successful!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Your request has been submitted.\nYou will be notified once it’s reviewed.',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 18),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.offAllNamed(AppRoutes.finalStatus);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _navy,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Back to Home',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: ctrl.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
