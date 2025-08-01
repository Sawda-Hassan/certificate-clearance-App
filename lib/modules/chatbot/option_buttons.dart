import 'package:flutter/material.dart';

class OptionButtons extends StatelessWidget {
  final Function(String) onOptionSelected;

  const OptionButtons({super.key, required this.onOptionSelected});

  final List<Map<String, dynamic>> quickOptions = const [
    {
      'text': 'Faculty Support',
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'text': 'Library Help',
      'icon': Icons.library_books,
      'color': Colors.green,
    },
    {
      'text': 'Lab Assistance',
      'icon': Icons.science,
      'color': Colors.orange,
    },
    {
      'text': 'Finance Inquiry',
      'icon': Icons.account_balance_wallet,
      'color': Colors.purple,
    },
    {
      'text': 'Exam Office',
      'icon': Icons.assignment,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: quickOptions.length,
        itemBuilder: (context, index) {
          final option = quickOptions[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onOptionSelected(option['text']),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (option['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        option['icon'],
                        color: option['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option['text'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
