import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'name_correction_screen.dart';
import 'appointment_screen.dart';
import 'main_screen.dart';

class IndividualClearanceScreen extends StatefulWidget {
  const IndividualClearanceScreen({super.key});

  @override
  State<IndividualClearanceScreen> createState() =>
      _IndividualClearanceScreenState();
}

class _IndividualClearanceScreenState extends State<IndividualClearanceScreen> {
  final individualData = {"Finance": "Approved", "Examination": "Approved"};

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

  void handleNextStep() async {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Yes, correct name"),
          ),
        ],
      ),
    );

    if (wantsCorrection == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NameCorrectionScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AppointmentScreen()),
      );
    }
  }

  void navigateToMain(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(initialIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Individual Clearance"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      onPressed: handleNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C3C78),
                        foregroundColor: Colors.white,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        onTap: navigateToMain,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
