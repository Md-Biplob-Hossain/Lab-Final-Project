import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_illustrations.dart';
import '../widgets/custom_rounded_button.dart';

class QuizConfigScreen extends StatefulWidget {
  const QuizConfigScreen({super.key});

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  late double _amount;
  late String _difficulty;
  late String _type;
  bool _isSubmitting = false;

  final List<String> _difficultyOptions = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard',
  ];

  final List<String> _typeOptions = [
    'Multiple Choice',
    'True / False',
  ];

  @override
  void initState() {
    super.initState();
    final quizProvider = context.read<QuizProvider>();
    _amount = quizProvider.amount.toDouble().clamp(1, 50);
    _difficulty = quizProvider.difficulty;
    _type = quizProvider.type;

    // Load persisted saved settings from SharedPreferences
    quizProvider.loadSavedConfig().then((_) {
      if (mounted) {
        setState(() {
          _amount = quizProvider.amount.toDouble().clamp(1, 50);
          _difficulty = quizProvider.difficulty;
          _type = quizProvider.type;
        });
      }
    });
  }

  void _onStartQuiz() async {
    final quizProvider = context.read<QuizProvider>();

    // Update config in provider & save to SharedPreferences
    quizProvider.setConfig(
      amount: _amount.round(),
      difficulty: _difficulty,
      type: _type,
    );
    await quizProvider.saveConfig();

    setState(() {
      _isSubmitting = true;
    });

    // Fetch questions
    final success = await quizProvider.startQuiz();

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.pushNamed(context, '/quiz');
    } else {
      // Show friendly error dialog asking user to adjust settings
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800)),
                SizedBox(width: 8),
                Text('Quiz Notice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              quizProvider.errorMessage ??
                  'Could not fetch questions with these settings. Try reducing the number of questions or selecting "Any Difficulty".',
              style: const TextStyle(fontSize: 15, color: Color(0xFF334155)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Adjust Settings',
                  style: TextStyle(
                    color: Color(0xFF0F4C4C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final categoryName = quizProvider.categoryName
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Small Decorative Illustration matching Figma
              const ConfigIllustration(height: 120),

              const SizedBox(height: 16),

              // Title "Quizzical"
              const Text(
                'Quizzical',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 4),

              // Subtitle "Configuration"
              const Text(
                'Configuration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 4),

              // Selected Category Name
              Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F4C4C),
                ),
              ),

              const SizedBox(height: 28),

              // Number of Questions Slider Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Number of Questions',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '${_amount.round()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select 1–50',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF2196F3),
                      inactiveTrackColor: const Color(0xFFE2E8F0),
                      thumbColor: const Color(0xFF2196F3),
                      overlayColor: const Color(0xFF2196F3).withValues(alpha: 0.2),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _amount,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_amount.round()}',
                      onChanged: (val) {
                        setState(() {
                          _amount = val;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Difficulty Level Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Difficulty Level',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _difficultyOptions.contains(_difficulty)
                        ? _difficulty
                        : _difficultyOptions.first,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0F4C4C), width: 2),
                      ),
                    ),
                    items: _difficultyOptions.map((diff) {
                      return DropdownMenuItem<String>(
                        value: diff,
                        child: Text(diff, style: const TextStyle(fontSize: 15)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _difficulty = val;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Question Type Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Question Type',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _typeOptions.contains(_type) ? _type : _typeOptions.first,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0F4C4C), width: 2),
                      ),
                    ),
                    items: _typeOptions.map((t) {
                      return DropdownMenuItem<String>(
                        value: t,
                        child: Text(t, style: const TextStyle(fontSize: 15)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _type = val;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // START Button (Outlined matching Figma Screen 3)
              CustomRoundedButton(
                text: 'START',
                isOutlined: true,
                color: const Color(0xFF0F4C4C),
                isLoading: _isSubmitting,
                onPressed: _onStartQuiz,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
