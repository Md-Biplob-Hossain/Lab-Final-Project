import 'package:flutter/foundation.dart' hide Category;
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  CategoryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Fetch categories with caching: won't refetch if already loaded unless [forceRefresh] is true
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }
}
