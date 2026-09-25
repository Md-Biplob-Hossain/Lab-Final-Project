import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';

void main() {
  group('Category Model Tests', () {
    test('Category.fromJson parses JSON correctly', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final category = Category.fromJson(json);

      expect(category.id, 9);
      expect(category.name, 'General Knowledge');
    });
  });

  group('Question Model Tests', () {
    test('Question.fromJson decodes HTML entities and caches options', () {
      final json = {
        'category': 'Entertainment: Books',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'Which author wrote &quot;Harry Potter&quot;?',
        'correct_answer': 'J.K. Rowling',
        'incorrect_answers': [
          'George R.R. Martin',
          'J.R.R. Tolkien',
          'C.S. Lewis'
        ]
      };

      final question = Question.fromJson(json);

      expect(question.category, 'Entertainment: Books');
      expect(question.question, 'Which author wrote "Harry Potter"?');
      expect(question.correctAnswer, 'J.K. Rowling');
      expect(question.incorrectAnswers.length, 3);
      expect(question.options.length, 4);
      expect(question.options.contains('J.K. Rowling'), true);

      // Verify options list is cached and doesn't change on subsequent reads
      final options1 = question.options;
      final options2 = question.options;
      expect(options1, options2);
    });
  });
}
