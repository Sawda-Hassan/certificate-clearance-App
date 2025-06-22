import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controlerr/nameupload_controller.dart';

const _navy = Color(0xFF0A2647);
const _lightBlue = Color(0xFFE8F3FF);

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CurvedAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _AppBarWaveClipper(),
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF022A42), Color(0xFF2E1B61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height * .75)
    ..quadraticBezierTo(size.width * .25, size.height, size.width * .5, size.height * .9)
    ..quadraticBezierTo(size.width * .75, size.height * .8, size.width, size.height * .9)
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class NameUploadPage extends StatelessWidget {
  const NameUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NameUploadController());
    final auth = Get.find<AuthController>();
    final studentId = auth.loggedInStudent.value?.id ?? '';
    final currentName = auth.loggedInStudent.value?.fullName ?? '';

    return Scaffold(
      appBar: const CurvedAppBar(title: "Name Correction"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your name you wish to appear on your certificate:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),

                // ✅ Text input with current name pre-filled
                TextFormField(
                  initialValue: ctrl.requestedName.value.isNotEmpty
                      ? ctrl.requestedName.value
                      : currentName,
                  onChanged: (value) => ctrl.requestedName.value = value.trim(),
                  decoration: InputDecoration(
                    hintText: "Tap to enter name",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _navy, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 58),
                const Text(
                  "📎 Upload document to verify this name",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text(
                  "High school certificate, passport, Birth certificate",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 14),

                // ✅ Upload Button with text color changed
                ElevatedButton(
                  onPressed: ctrl.pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Upload File",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // ✅ Changed text color
                    ),
                  ),
                ),

                if (ctrl.selectedFileName.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("📄 ${ctrl.selectedFileName.value}"),
                  ),

                const SizedBox(height: 64),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: ctrl.isConfirmed.value,
                      activeColor: _navy,
                      onChanged: (val) => ctrl.isConfirmed.value = val ?? false,
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

                const SizedBox(height: 16),

                // ✅ Progress bar only (no text)
                LinearProgressIndicator(
                  value: 1.0,
                  color: _navy,
                  backgroundColor: Colors.grey.shade200,
                  minHeight: 6,
                ),

                const SizedBox(height: 58),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.isFormValid ? () => ctrl.submit(studentId) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ctrl.isFormValid ? _navy : Colors.grey.shade400,
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
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
