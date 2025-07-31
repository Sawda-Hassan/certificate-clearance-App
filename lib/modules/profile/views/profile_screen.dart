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
      final route = Get.arguments?['returnToRoute'] ?? AppRoutes.finalStatus;
      Get.offAllNamed(route);
    },

        ),
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(color: Color.fromARGB(255, 255, 251, 251), fontSize: 24),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 14, 94),
      ),
      
      //bottomNavigationBar: const _BottomNav(),
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

