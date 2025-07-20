import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../chatbot/chatbot_badge_controller.dart';
import '../../chatbot/chatbot_screen.dart';
import '../../Final Clearance Status/veiw/final_clearance_status.dart';
class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
  Get.offAll(() => const FinalClearanceStatus());
},

        ),
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(color: Color.fromARGB(255, 255, 251, 251), fontSize: 24),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 14, 94),
      ),
      
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: Obx(() {
          final student = authController.loggedInStudent.value;
          if (student == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final ImageProvider profileImage = (student.profilePicture.isNotEmpty)
              ? NetworkImage(student.profilePicture)
              : AssetImage(
                  student.gender.toLowerCase() == 'female'
                      ? 'assets/images/girl_profile.png'
                      : 'assets/images/boy_profile.png',
                ) as ImageProvider;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // 🧑‍🎓 Header with Profile + Dots
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: [
                   
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 130,
                            width: double.infinity,
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: profileImage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        student.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 ID & Phone
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoCard("📘 ${student.studentId}", "StudentId", _navy),

                    _infoCard("📱 ${student.phone}", "Phone", Colors.orange),
                  ],
                ),

                const SizedBox(height: 25),

                // 🔹 Class, Year, Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoLabel("Class", student.studentClass),
                    _infoLabel("Graduation", student.yearOfGraduation.toString()),
                    _infoLabel("Status", student.status),
                  ],
                ),

                const SizedBox(height: 10),

                // 🚪 Styled Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        authController.logout();
                        Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A1E49), // Deep navy
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // pill shape
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // 📚 Academic Info
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Academic Information",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                _textRow("Mode", student.mode),
                _textRow("Year of Admission", student.yearOfAdmission.toString()),
                _textRow("Duration", "${student.duration} years"),

                const SizedBox(height: 20),

                // 👤 Personal Info
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Personal Information",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                _textRow("Gender", student.gender),
                _textRow("Mother's Name", student.motherName),
                _textRow("Email", student.email),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _infoCard(String value, String label, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoLabel(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _textRow(String label, String value) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    );
  }
}

// ---- Custom Bottom Navigation ----
const Color _navy = Color(0xFF0A1E49); // Deep navy color


class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final unread = Get.find<ChatbotBadgeController>().unreadCount;

    return Obx(() {
      return BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 33, 3, 102),
        unselectedItemColor: Colors.black.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'apointment',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Status',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/images/chat.png', width: 44, height: 44),
                if (unread.value > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Image.asset('assets/images/ca.png', width: 24, height: 24),
            label: 'Chatbot',
          ),
        ],
         onTap: (index) {
  switch (index) {
    case 0:
      Get.offAllNamed(AppRoutes.appointment);
      break;
    case 1:
      Get.offAllNamed(AppRoutes.finalStatus); // ✅ Add this line
      break;
    case 2:
      Get.offAllNamed(AppRoutes.notification);
      break;
    case 3:
      Get.offAllNamed(AppRoutes.profile);
      break;
    case 4:
      Get.to(() => ChatbotScreen());
      break;
  }
});});}

    }