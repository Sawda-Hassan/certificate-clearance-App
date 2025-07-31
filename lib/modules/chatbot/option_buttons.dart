import 'package:flutter/material.dart';

class OptionButtons extends StatelessWidget {
  final void Function(String) onOptionSelected;

  const OptionButtons({required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildButton("Where is my certificate?"),
        _buildButton("I paid my fees."),
        _buildButton("Contact faculty"),
        _buildButton("Back to general"), // Changed from "resolved"
      ],
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => onOptionSelected(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: text == "Back to general" ? Colors.green : Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}