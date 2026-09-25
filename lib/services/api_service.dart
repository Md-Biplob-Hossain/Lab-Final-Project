import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';
  static const Duration _timeoutDuration = Duration(seconds: 12);

  /// Fetch list of available categories from OpenTDB API
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/api_category.php');
    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final categoriesJson = data['trivia_categories'] as List<dynamic>? ?? [];
        return categoriesJson
            .map((jsonItem) => Category.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load categories from server (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw const SocketException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw TimeoutException('Request timed out. Please try again.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('An unexpected error occurred while fetching categories: $e');
    }
  }

  /// Fetch quiz questions with configured parameters
  Future<List<Question>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    final queryParams = <String, String>{
      'amount': amount.toString(),
      'category': categoryId.toString(),
    };

    // Format difficulty parameter
    final formattedDifficulty = difficulty.toLowerCase().trim();
    if (!formattedDifficulty.contains('any') && formattedDifficulty.isNotEmpty) {
      queryParams['difficulty'] = formattedDifficulty;
    }

    // Format type parameter ("multiple" or "boolean")
    final formattedType = type.toLowerCase().trim();
    if (formattedType.contains('multiple')) {
      queryParams['type'] = 'multiple';
    } else if (formattedType.contains('boolean') || formattedType.contains('true')) {
      queryParams['type'] = 'boolean';
    } else if (!formattedType.contains('any') && formattedType.isNotEmpty) {
      queryParams['type'] = formattedType;
    }

    final uri = Uri.parse('$_baseUrl/api.php').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final responseCode = data['response_code'] as int? ?? -1;

        if (responseCode == 0) {
          final results = data['results'] as List<dynamic>? ?? [];
          if (results.isEmpty) {
            throw Exception('No questions returned for this configuration.');
          }
          return results
              .map((qJson) => Question.fromJson(qJson as Map<String, dynamic>))
              .toList();
        } else if (responseCode == 1) {
          throw Exception(
            'Not enough questions available for the selected settings. Please lower the question count or select "Any Difficulty".',
          );
        } else if (responseCode == 2) {
          throw Exception('Invalid configuration parameters sent to OpenTDB.');
        } else {
          throw Exception('API error (Code $responseCode). Please try adjusting your settings.');
        }
      } else {
        throw HttpException('Server error (Status Code: ${response.statusCode})');
      }
    } on SocketException {
      throw const SocketException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw TimeoutException('Request timed out. Please try again.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to fetch questions: $e');
    }
  }
}
