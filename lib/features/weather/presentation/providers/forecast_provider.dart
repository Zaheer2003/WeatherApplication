import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/core/params/params.dart';
import 'package:weatherapp/features/weather/domain/entities/forecast_entity.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_weather_forecast.dart';
import 'package:weatherapp/features/weather/presentation/providers/weather_provider.dart'; // To get repository provider

class ForecastNotifier extends StateNotifier<AsyncValue<ForecastEntity>> {
  final GetWeatherForecast _getWeatherForecast;

  ForecastNotifier(this._getWeatherForecast) : super(const AsyncValue.loading());

  Future<void> getForecast(String city) async {
    state = const AsyncValue.loading();
    final result = await _getWeatherForecast(WeatherParams(city));
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (forecast) => state = AsyncValue.data(forecast),
    );
  }
}

// Provider for the GetWeatherForecast use case
final getWeatherForecastProvider = Provider<GetWeatherForecast>((ref) {
  return GetWeatherForecast(ref.watch(weatherRepositoryProvider));
});

// StateNotifierProvider for the ForecastNotifier
final forecastNotifierProvider =
    StateNotifierProvider<ForecastNotifier, AsyncValue<ForecastEntity>>((ref) {
  return ForecastNotifier(ref.watch(getWeatherForecastProvider));
});
