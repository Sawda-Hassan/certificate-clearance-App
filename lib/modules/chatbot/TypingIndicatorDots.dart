import 'package:flutter/material.dart';

class TypingIndicatorDots extends StatefulWidget {
  const TypingIndicatorDots({super.key});

  @override
  _TypingIndicatorDotsState createState() => _TypingIndicatorDotsState();
}

class _TypingIndicatorDotsState extends State<TypingIndicatorDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> dotOne, dotTwo, dotThree;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
          ..repeat();

    dotOne = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeInOut)));

    dotTwo = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeInOut)));

    dotThree = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          width: 6,
          height: 6 + animation.value,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDot(dotOne),
        _buildDot(dotTwo),
        _buildDot(dotThree),
      ],
    );
  }
}