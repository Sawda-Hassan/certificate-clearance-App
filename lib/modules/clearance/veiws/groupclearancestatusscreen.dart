import 'package:flutter/material.dart';

class groupclearancestatusscreen extends StatelessWidget {
  const groupclearancestatusscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> steps = [
      {
        "title": "Faculty",
        "icon": Icons.account_balance,
        "status": "Approved",
      },
      {
        "title": "Library",
        "icon": Icons.menu_book,
        "status": "Approved",
      },
      {
        "title": "LAB",
        "icon": Icons.science,
        "status": "Approved",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              color: const Color(0xFF0A2647),
              child: const Center(
                child: Text(
                  'Group Clearance Status',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Timeline-like list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: steps.length,
                separatorBuilder: (_, __) => Container(
                  height: 30,
                  width: 2,
                  color: const Color(0xFF0A2647),
                  margin: const EdgeInsets.only(left: 24),
                ),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0A2647),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(step["icon"], color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 16),
                      // Step Info
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 5),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                step["title"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FADF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(step["status"],
                                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Progress and button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: 1.0,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF0A2647)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Phase 1 Clearance 100% Completed', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to individual clearance screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2647),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'START INDIVIDUAL CLEARANCE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF0A2647),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
