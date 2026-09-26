import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int percentage;

  const ScoreBadge({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;

    if (percentage >= 80) {
      // Top tier: light green
      bgColor = const Color(0xFFC8F5D8);
      borderColor = const Color(0xFFA5D6A7);
      textColor = const Color(0xFF1B5E20);
    } else if (percentage >= 50) {
      // Mid tier: light yellow-green
      bgColor = const Color(0xFFE6F5C8);
      borderColor = const Color(0xFFC5E1A5);
      textColor = const Color(0xFF33691E);
    } else {
      // Low tier: red
      bgColor = const Color(0xFFF25C54);
      borderColor = const Color(0xFFD84315);
      textColor = const Color(0xFFFFFFFF);
    }

    return Container(
      width: 220,
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

