class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime dateTime;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
  });
}