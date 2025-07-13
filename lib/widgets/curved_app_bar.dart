import 'package:flutter/material.dart';
import 'appbar_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backToFinance; // ✅ Add this line

  const CurvedAppBar({
    Key? key,
    required this.title,
    this.backToFinance = false, // ✅ Default to false
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _AppBarWaveClipper(),
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF022A42), Color(0xFF2E1B61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (backToFinance) {
                      Get.offNamed('/finance-clearance');
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height * .75)
    ..quadraticBezierTo(size.width * .25, size.height, size.width * .5, size.height * .9)
    ..quadraticBezierTo(size.width * .75, size.height * .8, size.width, size.height * .9)
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

