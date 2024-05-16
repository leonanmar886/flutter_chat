import 'package:flutter/material.dart';

class CustomBubble extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;

  const CustomBubble({
    super.key,
    required this.child,
    this.color = Colors.white,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
