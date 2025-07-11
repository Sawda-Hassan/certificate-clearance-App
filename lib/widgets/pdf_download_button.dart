import 'package:flutter/material.dart';

class PdfDownloadButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PdfDownloadButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      child: ElevatedButton.icon(
        onPressed: onPressed ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download PDF coming soon...')),
              );
            },
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: const Text('Download PDF', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2647), // Navy blue
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
