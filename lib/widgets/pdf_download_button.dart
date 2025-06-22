// lib/widgets/pdf_download_button.dart
import 'package:flutter/material.dart';

class PdfDownloadButton extends StatelessWidget {
  const PdfDownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // You can replace this with actual PDF generation/download logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download PDF coming soon...')),
        );
      },
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Download PDF'),
    );
  }
}
