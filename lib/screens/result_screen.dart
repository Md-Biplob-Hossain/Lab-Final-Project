import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_rounded_button.dart';
import '../widgets/score_badge.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final score = quizProvider.score;
    final total = quizProvider.totalQuestions;
    final percentage = total > 0 ? ((score / total) * 100).round() : 0;
    final totalTime = quizProvider.totalElapsedSeconds;

    // 3-tier scoring logic
    final String illustrationAsset;
    final IconData illustrationFallbackIcon;
    final String title;
    final String feedbackMessage;

    if (percentage >= 80) {
      illustrationAsset = 'assets/images/success_illustration.svg';
      illustrationFallbackIcon = Icons.celebration;
      title = 'Congratulation';
      feedbackMessage = "You've got a great foundation. Ready to try a different category?";
    } else if (percentage >= 50) {
      illustrationAsset = 'assets/images/success_illustration.svg';
      illustrationFallbackIcon = Icons.celebration;
      title = 'Good Job!';
      feedbackMessage = "Nice work! A bit more practice and you'll master this category.";
    } else {
      illustrationAsset = 'assets/images/retry_illustration.svg';
      illustrationFallbackIcon = Icons.replay;
      title = 'Keep Trying!';
      feedbackMessage = "Don't give up! Practice makes perfect. Try again to improve your score";
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        quizProvider.resetQuiz();
        Navigator.popUntil(context, ModalRoute.withName('/categories'));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
                      child: Column(
                        children: [
                          const Spacer(),

                          // Top SVG Illustration (tier-based)
                          SvgPicture.asset(
                            illustrationAsset,
                            height: 270,
                            fit: BoxFit.contain,
                            placeholderBuilder: (BuildContext context) => Icon(illustrationFallbackIcon, size: 100),
                          ),

                          const SizedBox(height: 24),

                          // Title
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Score Badge Pill (80%, 33%, etc.)
                          ScoreBadge(percentage: percentage),

                          const SizedBox(height: 24),

                          // Feedback Message
                          Text(
                            feedbackMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Quick Stats Row (Correct, Accuracy, Time)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatTile(
                                  label: 'Correct',
                                  value: '$score / $total',
                                  icon: Icons.check_circle_outline_rounded,
                                  color: const Color(0xFF4CAF50),
                                ),
                                Container(height: 36, width: 1, color: const Color(0xFFCBD5E1)),
                                _StatTile(
                                  label: 'Accuracy',
                                  value: '$percentage%',
                                  icon: Icons.pie_chart_outline_rounded,
                                  color: const Color(0xFF2196F3),
                                ),
                                Container(height: 36, width: 1, color: const Color(0xFFCBD5E1)),
                                _StatTile(
                                  label: 'Time Taken',
                                  value: _formatTime(totalTime),
                                  icon: Icons.timer_outlined,
                                  color: const Color(0xFFFF9800),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Bottom Button "PLAY AGAIN"
                          CustomRoundedButton(
                            text: 'PLAY AGAIN',
                            color: const Color(0xFF0F4C4C),
                            onPressed: () {
                              quizProvider.resetQuiz();
                              Navigator.popUntil(context, ModalRoute.withName('/categories'));
                            },
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
