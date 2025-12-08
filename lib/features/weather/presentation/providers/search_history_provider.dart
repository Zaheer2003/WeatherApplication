import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  static const _key = 'searchHistory';
  static const _maxHistoryLength = 5; // Limit history to 5 items

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    state = history;
  }

  Future<void> addCity(String city) async {
    final normalizedCity = city.trim();
    if (normalizedCity.isEmpty) return;

    final updatedHistory = List<String>.from(state);
    updatedHistory.removeWhere((item) => item.toLowerCase() == normalizedCity.toLowerCase()); // Remove duplicates
    updatedHistory.insert(0, normalizedCity); // Add to the beginning

    if (updatedHistory.length > _maxHistoryLength) {
      updatedHistory.removeLast(); // Keep only the latest N items
    }

    state = updatedHistory;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state);
  }

  Future<void> removeCity(String city) async {
    final updatedHistory = List<String>.from(state);
    updatedHistory.removeWhere((item) => item.toLowerCase() == city.toLowerCase());
    state = updatedHistory;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state);
  }

  Future<void> clearHistory() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});