import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'name_correction_screen.dart';
import 'appointment_screen.dart'; // Make sure this screen exists

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final groupData = {
    "Faculty": "Approved",
    "Library": "Approved",
    "Lab": "Approved",
  };

  final individualData = {"Finance": "Approved", "Examination": "Approved"};

  bool get isGroupComplete => groupData.values.every((v) => v == "Approved");

  Widget buildStepItem(
    String title,
    String status,
    IconData icon, {
    bool showLine = true,
  }) {
    Color statusColor = status == "Approved"
        ? Colors.green
        : status == "Rejected"
        ? Colors.red
        : Colors.orange;

    IconData statusIcon = status == "Approved"
        ? Icons.check_circle
        : status == "Rejected"
        ? Icons.cancel
        : Icons.hourglass_top;

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0C3C78),
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        if (showLine)
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Container(
              height: 40,
              width: 2.5,
              color: Colors.blue.shade900,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: const BoxDecoration(
              color: Color(0xFF0C3C78),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Text(
                'Clearance Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Group Phase",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  buildStepItem(
                    "Faculty",
                    groupData["Faculty"]!,
                    Icons.account_balance,
                  ),
                  buildStepItem(
                    "Library",
                    groupData["Library"]!,
                    Icons.menu_book,
                  ),
                  buildStepItem(
                    "Lab",
                    groupData["Lab"]!,
                    Icons.science,
                    showLine: false,
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF0C3C78)),
                    minHeight: 14,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Phase 1 Clearance Progress",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Individual Phase",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  buildStepItem(
                    "Finance",
                    individualData["Finance"]!,
                    Icons.attach_money,
                  ),
                  buildStepItem(
                    "Examination",
                    individualData["Examination"]!,
                    Icons.school,
                    showLine: false,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () async {
                        final wantsCorrection = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Name Correction"),
                            content: const Text(
                              "Would you like to request a name correction before your certificate is issued?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("No"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Yes, correct name"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primary, // 🔵 button background
                                  foregroundColor:
                                      Colors.white, // ✅ icon + text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (wantsCorrection == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NameCorrectionScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppointmentScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C3C78),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "PROCEED TO NEXT STEP",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
