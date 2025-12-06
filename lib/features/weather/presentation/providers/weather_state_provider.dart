import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/core/params/params.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_weather.dart';
import 'package:weatherapp/features/weather/presentation/providers/weather_provider.dart';

class WeatherState {
  final bool isLoading;
  final WeatherEntity? weather;
  final String? error;

  WeatherState({
    this.isLoading = false,
    this.weather,
    this.error,
  });

  WeatherState copyWith({
    bool? isLoading,
    WeatherEntity? weather,
    String? error,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final GetWeather _getWeather;

  WeatherNotifier(this._getWeather) : super(WeatherState());

  Future<void> getWeather(String city) async {
    state = state.copyWith(isLoading: true);
    final result = await _getWeather(WeatherParams(city));
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (weather) => state = state.copyWith(
        isLoading: false,
        weather: weather,
      ),
    );
  }
}

final weatherNotifierProvider = StateNotifierProvider<WeatherNotifier, WeatherState>(
  (ref) => WeatherNotifier(
    ref.watch(getWeatherProvider),
  ),
);
