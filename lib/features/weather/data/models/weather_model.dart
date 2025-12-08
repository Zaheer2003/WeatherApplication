import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';
import 'package:weatherapp/features/weather/domain/weather_model.dart'; // Import WeatherAlert

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required String cityName,
    required String description,
    required double temperature,
    required double feelsLike,
    required double tempMin,
    required double tempMax,
    required int humidity,
    required double windSpeed,
    required int pressure,
    required DateTime sunrise,
    required DateTime sunset,
    required List<WeatherAlert> alerts,
    required int dt,
  }) : super(
          cityName: cityName,
          description: description,
          temperature: temperature,
          feelsLike: feelsLike,
          tempMin: tempMin,
          tempMax: tempMax,
          humidity: humidity,
          windSpeed: windSpeed,
          pressure: pressure,
          sunrise: sunrise,
          sunset: sunset,
          alerts: alerts,
          dt: dt,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      alerts: (json['alerts'] as List?)
              ?.map((alertJson) => WeatherAlert.fromJson(alertJson))
              .toList() ??
          [],
      dt: json['dt'],
    );
  }
}
