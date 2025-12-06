import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/features/weather/domain/weather_model.dart';

class WeatherApiService {
  final String apiKey = "11764c584cfd4a4d50a90683a0a39656";
  final String unit;

  WeatherApiService(this.unit);

  Future<Weather> fetchWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=$unit&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    return Weather.fromJson(json.decode(response.body));
  }

  Future<List<Forecast>> fetchForecast(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$unit&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load forecast data');
    }

    final data = json.decode(response.body);
    final list = data['list'] as List;

    return list.map((item) => Forecast.fromJson(item)).toList();
  }
}