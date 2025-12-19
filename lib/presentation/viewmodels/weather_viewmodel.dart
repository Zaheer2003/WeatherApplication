import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/city.dart';
import '../../data/datasources/weather_api.dart';
import '../../data/datasources/location_service.dart';
import '../../data/datasources/favorites_storage.dart';

class WeatherState {
  final Weather? currentWeather;
  final List<Forecast> forecast;
  final List<City> favorites;
  final List<City> searchResults;
  final bool isLoading;
  final String? error;

  WeatherState({
    this.currentWeather,
    this.forecast = const [],
    this.favorites = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    Weather? currentWeather,
    List<Forecast>? forecast,
    List<City>? favorites,
    List<City>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      favorites: favorites ?? this.favorites,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WeatherViewModel extends StateNotifier<WeatherState> {
  final WeatherApi _weatherApi = WeatherApi();
  final LocationService _locationService = LocationService();
  final FavoritesStorage _favoritesStorage = FavoritesStorage();

  WeatherViewModel() : super(WeatherState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadFavorites();
    getCurrentLocationWeather();
  }

  Future<void> getCurrentLocationWeather() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await _locationService.getCurrentLocation();
      final weather = await _weatherApi.getCurrentWeather(position.latitude, position.longitude);
      final forecast = await _weatherApi.get7DayForecast(position.latitude, position.longitude);
      state = state.copyWith(currentWeather: weather, forecast: forecast, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> getWeatherForCity(City city) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final weather = await _weatherApi.getCurrentWeather(city.lat, city.lon);
      final forecast = await _weatherApi.get7DayForecast(city.lat, city.lon);
      state = state.copyWith(currentWeather: weather, forecast: forecast, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }
    try {
      final results = await _weatherApi.searchCities(query);
      state = state.copyWith(searchResults: results);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addToFavorites(City city) async {
    if (state.favorites.any((c) => c.name == city.name && c.country == city.country)) {
      return; 
    }
    final newFavorites = [...state.favorites, city];
    await _favoritesStorage.saveFavorites(newFavorites);
    state = state.copyWith(favorites: newFavorites);
    await loadFavorites();
  }

  Future<void> removeFromFavorites(City city) async {
    final newFavorites = state.favorites.where((c) => c.name != city.name || c.country != city.country).toList();
    await _favoritesStorage.saveFavorites(newFavorites);
    state = state.copyWith(favorites: newFavorites);
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await _favoritesStorage.getFavorites();
      state = state.copyWith(favorites: favorites);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load favorites: $e');
    }
  }
}