import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';

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
  }) : super(
          cityName: cityName,
          description: description,
          temperature: temperature,
          feelsLike: feelsLike,
          tempMin: tempMin,
          tempMax: tempMax,
          humidity: humidity,
          windSpeed: windSpeed,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
