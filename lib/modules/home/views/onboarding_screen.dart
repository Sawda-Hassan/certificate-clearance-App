import 'package:flutter/material.dart';
import 'package:clearance_app/modules/auth/views/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 12, 48, 107),
              Color.fromARGB(255, 23, 197, 245),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Image.asset(
              'assets/images/C.png',
              height: 145,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, color: Colors.white, size: 100),
            ),
            const SizedBox(height: 24),
            const Text(
              'AUTOMATION CERTIFICATE\nCLEARANCE UNIVERSITY APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D80),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
