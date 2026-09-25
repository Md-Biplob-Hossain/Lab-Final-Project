import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/custom_rounded_button.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Exit Quiz?'),
          content: const Text(
            'Are you sure you want to exit? Your quiz progress will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<QuizProvider>().resetQuiz();
      Navigator.popUntil(context, ModalRoute.withName('/categories'));
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final currentQuestion = quizProvider.currentQuestion;

    if (currentQuestion == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No question available.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentIndex = quizProvider.currentIndex;
    final totalQuestions = quizProvider.totalQuestions;
    final progress = totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0.0;
    final isAnswered = quizProvider.isAnswered;
    final isLast = quizProvider.isLastQuestion;
    final selectedAnswer = quizProvider.currentSelectedAnswer;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitConfirmation(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              children: [
                // Top Row Header: {currentIndex}/{total} and EXIT button (matching Figma)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60), // Spacer balancing EXIT
                    // Centered {currentIndex}/{total}
                    Text(
                      '${currentIndex + 1}/$totalQuestions',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    // Right-aligned EXIT Button
                    InkWell(
                      onTap: () => _showExitConfirmation(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'EXIT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.logout_rounded,
                              size: 20,
                              color: Color(0xFF1E293B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // LinearProgressIndicator below top row
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                ),

                const SizedBox(height: 12),

                // Countdown Timer Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: quizProvider.remainingSeconds <= 5
                              ? const Color(0xFFE53935)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${quizProvider.remainingSeconds}s',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: quizProvider.remainingSeconds <= 5
                                ? const Color(0xFFE53935)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    if (isAnswered && selectedAnswer == '')
                      const Text(
                        'Time Expired!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Question Card (White rounded card matching Figma)
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 160),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Answer Options List
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      final isThisSelected = selectedAnswer == option;
                      final isThisCorrect = option == currentQuestion.correctAnswer;

                      return AnswerOptionTile(
                        optionText: option,
                        isSelected: isThisSelected,
                        isCorrect: isThisCorrect,
                        isAnswered: isAnswered,
                        onTap: () {
                          quizProvider.selectAnswer(option);
                        },
                      );
                    },
                  ),
                ),

                // Bottom Dark Teal Button ("Next" or "See Results")
                CustomRoundedButton(
                  text: isLast ? 'See Results' : 'Next',
                  color: const Color(0xFF0F4C4C),
                  onPressed: isAnswered
                      ? () {
                          if (isLast) {
                            Navigator.pushReplacementNamed(context, '/result');
                          } else {
                            quizProvider.nextQuestion();
                          }
                        }
                      : null,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
