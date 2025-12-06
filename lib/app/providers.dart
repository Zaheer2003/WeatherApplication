import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/data/favorites_repository.dart';
import 'package:weatherapp/features/weather/data/location_service.dart';
import 'package:weatherapp/features/weather/domain/weather_repository.dart';
import '../features/weather/data/weather_api_service.dart';
import '../features/weather/data/weather_repository_impl.dart';
import '../features/weather/domain/weather_model.dart';

final cityProvider = StateProvider<String>((ref) => 'London');
final temperatureUnitProvider = StateProvider<String>((ref) => 'metric');

final weatherApiServiceProvider = Provider((ref) {
  final unit = ref.watch(temperatureUnitProvider);
  return WeatherApiService(unit);
});

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    ref.read(weatherApiServiceProvider),
  ),
);

final weatherProvider = FutureProvider<Weather>((ref) {
  final city = ref.watch(cityProvider);
  return ref.read(weatherRepositoryProvider).getWeather(city);
});

final forecastProvider = FutureProvider<List<Forecast>>((ref) {
  final city = ref.watch(cityProvider);
  return ref.read(weatherRepositoryProvider).getForecast(city);
});

final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

final favoritesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(favoritesRepositoryProvider).getFavorites();
});

final isFavoriteProvider = FutureProvider<bool>((ref) async {
  final city = ref.watch(cityProvider);
  final favorites = await ref.watch(favoritesProvider.future);
  return favorites.contains(city);
});

final locationServiceProvider = Provider((ref) => LocationService());