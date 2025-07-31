import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ Import all tab screens (update these paths if needed)
import '../../modules/appointments/views/appointment_page.dart';
import '../Final Clearance Status/veiw/final_clearance_status.dart';
import '../../modules/notification/view/notification_screen.dart';
import '../../modules/profile/views/profile_screen.dart';
import '../chatbot/chatbot_screen.dart';

class MainTabsScreen extends StatefulWidget {
  final int initialIndex;
  const MainTabsScreen({super.key, this.initialIndex = 1}); // Default to Final Status tab

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

final List<Widget> _screens = [
  AppointmentPage(),
  FinalClearanceStatus(),
  NotificationScreen(),
  ProfileScreen(),
  ChatbotScreen(),
];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: const Color(0xFF0A2647),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
        ],
      ),
    );
  }
}
