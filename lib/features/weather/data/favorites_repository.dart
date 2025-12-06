import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const _favoritesKey = 'favorite_cities';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(city)) {
      favorites.add(city);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (favorites.contains(city)) {
      favorites.remove(city);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }
}
