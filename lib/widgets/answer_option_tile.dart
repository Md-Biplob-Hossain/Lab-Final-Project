import 'package:flutter/material.dart';

class AnswerOptionTile extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const AnswerOptionTile({
    super.key,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = const Color(0xFF1E293B);
    Widget circleIndicator = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF94A3B8), width: 1.8),
      ),
    );

    // Matching Figma design: only the SELECTED option changes color!
    if (isAnswered && isSelected) {
      if (isCorrect) {
        // Mint green background for correct selection
        backgroundColor = const Color(0xFFA8E6C1);
        textColor = const Color(0xFF0F4C4C);
        circleIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF0F4C4C),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 16,
            color: Colors.white,
          ),
        );
      } else {
        // Salmon red background for incorrect selection
        backgroundColor = const Color(0xFFF28B82);
        textColor = const Color(0xFF78281F);
        circleIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFE53935),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 16,
            color: Colors.white,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Semantics(
        button: true,
        selected: isSelected,
        enabled: !isAnswered,
        label: 'Answer option: $optionText',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isAnswered ? null : onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      optionText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  circleIndicator,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
