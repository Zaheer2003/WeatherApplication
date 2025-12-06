class WeatherEntity {
  final String cityName;
  final String description;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;

  WeatherEntity({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
  });
}
