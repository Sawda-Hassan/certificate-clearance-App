import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/name_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/curved_app_bar.dart';

const _navy = Color(0xFF0A2647);
const _lightBlue = Color(0xFFE8F3FF);

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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              insetPadding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Confirm Change',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Are you sure you want to request a name correction?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13.5),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Navigator.pop(context),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.red),
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await ctrl.setCorrectionRequested(true);
                                              Get.toNamed(AppRoutes.nameUpload);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _navy,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Yes, Continue", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              insetPadding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Confirm Selection',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Are you sure your name is correct and you don't want to change it?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13.5),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Navigator.pop(context),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.red),
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await ctrl.setCorrectionRequested(false);

                                              // ✅ Show only Back to Home
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    insetPadding: const EdgeInsets.symmetric(horizontal: 50),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Icon(Icons.check_circle, color: Colors.green, size: 32),
                                                          const SizedBox(height: 12),
                                                          const Text(
                                                            'Confirmation Successful!',
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 6),
                                                          const Text(
                                                            'Your selection has been confirmed.\nYour appointment will be notified soon.',
                                                            style: TextStyle(fontSize: 13, color: Colors.black87),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 20),
                                                          // ✅ No OK — Just go home
                                                          GestureDetector(
                                                            onTap: () => Get.offAllNamed(AppRoutes.finalStatus),
                                                            child: const Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.arrow_back, size: 15, color: Colors.black54),
                                                                SizedBox(width: 5),
                                                                Text('Back to Home', style: TextStyle(fontSize: 13, color: Colors.black54)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _navy,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Yes, It's Correct", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
                const SizedBox(height: 80),
              ],
            ),
          );
        }),
      ),
    );
  }
}
