import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyAmount = 'quiz_amount';
  static const String _keyDifficulty = 'quiz_difficulty';
  static const String _keyType = 'quiz_type';

  /// Save quiz configuration locally
  Future<void> saveConfig({
    required int amount,
    required String difficulty,
    required String type,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAmount, amount);
    await prefs.setString(_keyDifficulty, difficulty);
    await prefs.setString(_keyType, type);
  }

  /// Load stored quiz configuration
  Future<Map<String, dynamic>> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'amount': prefs.getInt(_keyAmount) ?? 10,
      'difficulty': prefs.getString(_keyDifficulty) ?? 'Any Difficulty',
      'type': prefs.getString(_keyType) ?? 'Multiple Choice',
    };
  }
}
