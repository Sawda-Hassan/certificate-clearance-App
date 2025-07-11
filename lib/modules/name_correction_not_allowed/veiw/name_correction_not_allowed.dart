import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameCorrectionNotAllowedPage extends StatelessWidget {
  const NameCorrectionNotAllowedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Name Correction"),
        backgroundColor: const Color(0xFF0A2647),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 100, color: Colors.red),
              const SizedBox(height: 30),
              const Text(
                "Name Correction Not Allowed",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A2647)),
              ),
              const SizedBox(height: 16),
              const Text(
                "You’ve already completed your certificate process. Name correction is no longer allowed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Get.offAllNamed('/status'),
                icon: const Icon(Icons.home),
                label: const Text("Back to Status"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2647),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
