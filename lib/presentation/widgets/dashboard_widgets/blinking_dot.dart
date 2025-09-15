import 'package:flutter/material.dart';

/// A widget that displays a blinking dot with a given color.
class BlinkingDot extends StatefulWidget {
  /// Creates a blinking dot.
  const BlinkingDot({super.key, required this.color});

  /// The color of the dot.
  final Color color;

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color, blurRadius: 10, spreadRadius: 3),
          ],
        ),
      ),
    );
  }
}
