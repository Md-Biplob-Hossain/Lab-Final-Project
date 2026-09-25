import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int percentage;

  const ScoreBadge({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassed = percentage >= 50;
    final Color bgColor = isPassed ? const Color(0xFFC8F5D8) : const Color(0xFFFFCCBC);
    final Color borderColor = isPassed ? const Color(0xFFA5D6A7) : const Color(0xFFFF8A80);
    final Color textColor = isPassed ? const Color(0xFF1B5E20) : const Color(0xFFD84315);

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
