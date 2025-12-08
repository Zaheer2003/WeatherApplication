
class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final List<WeatherAlert> alerts;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    this.alerts = const [], // Default to empty list
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown City',
      temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
      description: json['weather']?[0]?['description'] ?? 'No description',
      icon: json['weather']?[0]?['icon'] ?? '',
      feelsLike: (json['main']?['feels_like'] ?? 0.0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      pressure: json['main']?['pressure'] ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch((json['sys']?['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((json['sys']?['sunset'] ?? 0) * 1000),
      alerts: (json['alerts'] as List?)
              ?.map((alertJson) => WeatherAlert.fromJson(alertJson))
              .toList() ??
          [],
    );
  }
}

class WeatherAlert {
  final String event;
  final DateTime start;
  final DateTime end;
  final String description;
  final String senderName;

  WeatherAlert({
    required this.event,
    required this.start,
    required this.end,
    required this.description,
    required this.senderName,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      event: json['event'] ?? 'Unknown Event',
      start: DateTime.fromMillisecondsSinceEpoch((json['start'] ?? 0) * 1000),
      end: DateTime.fromMillisecondsSinceEpoch((json['end'] ?? 0) * 1000),
      description: json['description'] ?? 'No description',
      senderName: json['sender_name'] ?? 'Unknown Sender',
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
      description: json['weather']?[0]?['description'] ?? 'No description',
      icon: json['weather']?[0]?['icon'] ?? '',
    );
  }
}