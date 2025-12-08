import 'package:weatherapp/features/weather/domain/weather_model.dart';

class WeatherEntity {
  final String cityName;
  final String description;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final List<WeatherAlert> alerts;
  final int dt;

  WeatherEntity({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.alerts,
    required this.dt,
  });
}
