import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class QuizProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  // Configuration
  int _amount = 10;
  String _difficulty = 'Any Difficulty';
  String _type = 'Multiple Choice';
  int? _categoryId;
  String _categoryName = 'General Knowledge';

  // Quiz State
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  final Map<int, String> _selectedAnswers = {};
  bool _isAnswered = false;

  // Loading & Error State
  bool _isLoading = false;
  String? _errorMessage;

  // Timer State
  static const int questionDuration = 25; // 25 seconds per question
  int _remainingSeconds = questionDuration;
  Timer? _questionTimer;
  Timer? _autoAdvanceTimer;

  // Elapsed Time Tracking
  final Stopwatch _elapsedStopwatch = Stopwatch();

  QuizProvider({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService();

  // Getters
  int get amount => _amount;
  String get difficulty => _difficulty;
  String get type => _type;
  int? get categoryId => _categoryId;
  String get categoryName => _categoryName;

  List<Question> get questions => List.unmodifiable(_questions);
  int get totalQuestions => _questions.length;
  int get currentIndex => _currentIndex;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  int get score => _score;
  Map<int, String> get selectedAnswers => Map.unmodifiable(_selectedAnswers);
  String? get currentSelectedAnswer => _selectedAnswers[_currentIndex];
  bool get isAnswered => _isAnswered;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get remainingSeconds => _remainingSeconds;
  int get totalElapsedSeconds => _elapsedStopwatch.elapsed.inSeconds;

  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentIndex == _questions.length - 1;

  /// Load initial config from SharedPreferences
  Future<void> loadSavedConfig() async {
    try {
      final saved = await _storageService.loadConfig();
      _amount = saved['amount'] as int? ?? 10;
      _difficulty = saved['difficulty'] as String? ?? 'Any Difficulty';
      _type = saved['type'] as String? ?? 'Multiple Choice';
      notifyListeners();
    } catch (_) {
      // Fallback to defaults
    }
  }

  /// Update quiz configuration parameters
  void setConfig({
    int? amount,
    String? difficulty,
    String? type,
    int? categoryId,
    String? categoryName,
  }) {
    if (amount != null) _amount = amount;
    if (difficulty != null) _difficulty = difficulty;
    if (type != null) _type = type;
    if (categoryId != null) _categoryId = categoryId;
    if (categoryName != null) _categoryName = categoryName;
    notifyListeners();
  }

  /// Save current configuration to SharedPreferences
  Future<void> saveConfig() async {
    await _storageService.saveConfig(
      amount: _amount,
      difficulty: _difficulty,
      type: _type,
    );
  }

  /// Start a new quiz session by fetching questions from API
  Future<bool> startQuiz() async {
    if (_categoryId == null) {
      _errorMessage = 'Please select a category first.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchQuestions(
        amount: _amount,
        categoryId: _categoryId!,
        difficulty: _difficulty,
        type: _type,
      );

      _questions = fetched;
      _currentIndex = 0;
      _score = 0;
      _selectedAnswers.clear();
      _isAnswered = false;

      _isLoading = false;
      _errorMessage = null;

      // Start total stopwatch and start timer for first question
      _elapsedStopwatch.reset();
      _elapsedStopwatch.start();
      _startQuestionTimer();

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Select an answer for the current question
  void selectAnswer(String answer) {
    if (_isAnswered || currentQuestion == null) return;

    _cancelTimers();
    _isAnswered = true;
    _selectedAnswers[_currentIndex] = answer;

    if (answer == currentQuestion!.correctAnswer) {
      _score++;
    }

    notifyListeners();
  }

  /// Start the 25-second countdown timer for current question
  void _startQuestionTimer() {
    _cancelTimers();
    _remainingSeconds = questionDuration;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _onQuestionTimeout();
      }
    });
  }

  /// Handle question timer timeout
  void _onQuestionTimeout() {
    if (_isAnswered) return;

    _cancelTimers();
    _isAnswered = true;
    _selectedAnswers[_currentIndex] = ''; // Empty string indicates timeout/no selection

    notifyListeners();

    // Auto-advance shortly after timeout (1.5s delay)
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isAnswered && !isLastQuestion) {
        nextQuestion();
      }
    });
  }

  /// Move to the next question or complete quiz
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _cancelTimers();
      _currentIndex++;
      _isAnswered = false;
      _startQuestionTimer();
      notifyListeners();
    } else {
      // Quiz finished
      _cancelTimers();
      _elapsedStopwatch.stop();
      notifyListeners();
    }
  }

  /// Cancel all active timers safely
  void _cancelTimers() {
    _questionTimer?.cancel();
    _questionTimer = null;
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  /// Fully reset quiz state (when tapping Play Again or Exit)
  void resetQuiz() {
    _cancelTimers();
    _elapsedStopwatch.stop();
    _elapsedStopwatch.reset();

    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _selectedAnswers.clear();
    _isAnswered = false;
    _isLoading = false;
    _errorMessage = null;
    _remainingSeconds = questionDuration;

    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimers();
    _elapsedStopwatch.stop();
    super.dispose();
  }
}
