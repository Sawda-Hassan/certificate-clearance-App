import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/name_controller.dart';
import '../../../routes/app_routes.dart';

const _navy = Color(0xFF0A2647);
const _lightBlue = Color(0xFFE8F3FF);

// Curved AppBar with back arrow
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

// Name Verification Page
class NameVerificationPage extends StatelessWidget {
  const NameVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NameController());

    return Scaffold(
      appBar: const CurvedAppBar(title: 'Name Correction'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Is your name displayed correctly on the certificate?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ctrl.student.value?.fullName ?? 'Loading...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _navy,
                    ),
                  ),
                ),
                const SizedBox(height: 88),
                const Text(
                  'Would you like to change your name?',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // YES button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await ctrl.setCorrectionRequested(true);
                          if (ctrl.correctionRequested.value == true) {
                            Get.toNamed(AppRoutes.nameUpload);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: ctrl.correctionRequested.value == true ? _navy : Colors.grey,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: _navy,
                            fontWeight: ctrl.correctionRequested.value == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // NO button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => ctrl.setCorrectionRequested(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: ctrl.correctionRequested.value == false ? _navy : Colors.grey,
                          ),
                          backgroundColor: ctrl.correctionRequested.value == false
                              ? _navy
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: ctrl.correctionRequested.value == false ? Colors.white : _navy,
                            fontWeight: ctrl.correctionRequested.value == false
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 133),

                // Request Certificate Button - only enabled if correctionRequested == false
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.correctionRequested.value == false
    ? () async {
        await ctrl.requestCertificate();
        Get.toNamed(AppRoutes.appointment); // Navigate anyway
      }
    : null,

               
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ctrl.correctionRequested.value == false
                          ? _navy
                          : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Request certificate',
                      style: TextStyle(fontSize: 16),
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
