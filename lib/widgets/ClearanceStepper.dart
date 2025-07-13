import 'package:flutter/material.dart';
import '../modules/FacultyClearancepage/model/faculty_models.dart' as custom;

const _green = Color(0xFF35C651);
const _navy = Color.fromARGB(255, 15, 1, 95);

class ClearanceStepper extends StatelessWidget {
  final List<custom.ClearanceStep> steps;
  final double progress;

  const ClearanceStepper({
    super.key,
    required this.steps,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background line
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Container(height: 2, color: Colors.grey.shade300),
          ),

          // Progress line
          Positioned(
            top: 14,
            left: 0,
            right: MediaQuery.of(context).size.width * (1 - progress.clamp(0.0, 1.0)),
            child: Container(height: 2, color: _green),
          ),

          // Step indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((custom.ClearanceStep step) {
              final isCleared = step.state == custom.StepState.approved;

              return Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isCleared ? _green : _navy,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCleared ? _green : Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      isCleared ? Icons.check : Icons.lock,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCleared ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
