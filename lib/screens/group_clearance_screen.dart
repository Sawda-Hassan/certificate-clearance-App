import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'individual_clearance_screen.dart';

class GroupClearanceScreen extends StatelessWidget {
  const GroupClearanceScreen({super.key});

  final Map<String, String> groupStatus = const {
    "Faculty": "Approved",
    "Library": "Approved",
    "Lab": "Approved",
  };

  bool isComplete(Map<String, String> status) {
    return status.values.every((s) => s == "Approved");
  }

  Widget buildItem(
    String title,
    String status,
    IconData icon, {
    bool showLine = true,
  }) {
    Color color = status == "Approved"
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
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, size: 14, color: color),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (showLine)
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Container(
              height: 30,
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
    bool complete = isComplete(groupStatus);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Group Clearance"),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            buildItem(
              "Faculty",
              groupStatus["Faculty"]!,
              Icons.account_balance,
            ),
            buildItem("Library", groupStatus["Library"]!, Icons.menu_book),
            buildItem(
              "Lab",
              groupStatus["Lab"]!,
              Icons.science,
              showLine: false,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: complete ? 1.0 : 0.66,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF0C3C78)),
              minHeight: 14,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            const Text(
              "Group Clearance Progress",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: complete
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const IndividualClearanceScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "PROCEED TO INDIVIDUAL PHASE",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
