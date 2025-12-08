import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/data/favorites_repository.dart';

// Provider for the FavoritesRepository
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

// State Notifier for Favorites
class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _repository.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addFavorite(String city) async {
    await _repository.addFavorite(city);
    _loadFavorites();
  }

  Future<void> removeFavorite(String city) async {
    await _repository.removeFavorite(city);
    _loadFavorites();
  }

  Future<void> toggleFavorite(String city) async {
    final favorites = state.value ?? [];
    if (favorites.contains(city)) {
      await removeFavorite(city);
    } else {
      await addFavorite(city);
    }
  }
}

// StateNotifierProvider for the FavoritesNotifier
final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});
