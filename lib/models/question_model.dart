import 'package:html_unescape/html_unescape.dart';

class Question {
  final String category;
  final String type; // "multiple" or "boolean"
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> options; // Shuffled once and cached

  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    final categoryStr = unescape.convert(json['category'] as String? ?? '');
    final typeStr = json['type'] as String? ?? 'multiple';
    final difficultyStr = json['difficulty'] as String? ?? 'easy';
    final questionStr = unescape.convert(json['question'] as String? ?? '');
    final correctStr = unescape.convert(json['correct_answer'] as String? ?? '');

    final rawIncorrect = (json['incorrect_answers'] as List<dynamic>?) ?? [];
    final incorrectList = rawIncorrect
        .map((e) => unescape.convert(e.toString()))
        .toList();

    // Combine correct and incorrect answers and shuffle once for caching
    final allOptions = <String>[correctStr, ...incorrectList];
    allOptions.shuffle();

    return Question(
      category: categoryStr,
      type: typeStr,
      difficulty: difficultyStr,
      question: questionStr,
      correctAnswer: correctStr,
      incorrectAnswers: incorrectList,
      options: List.unmodifiable(allOptions),
    );
  }
}
