import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/city.dart';

class WeatherApi {
  static const String _apiKey = '659650949c7735ded689c3208ca127f7';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'));
    final data = json.decode(response.body);
    
    return Weather(
      cityName: data['name'],
      temperature: data['main']['temp'].toDouble(),
      condition: data['weather'][0]['main'],
      description: data['weather'][0]['description'],
      icon: data['weather'][0]['icon'],
      humidity: data['main']['humidity'].toDouble(),
      windSpeed: data['wind']['speed'].toDouble(),
      pressure: data['main']['pressure'].toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000),
      dateTime: DateTime.now(),
    );
  }

  Future<List<Forecast>> get7DayForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'));
    final data = json.decode(response.body);
    
    return (data['list'] as List).map((item) => Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
      maxTemp: item['main']['temp_max'].toDouble(),
      minTemp: item['main']['temp_min'].toDouble(),
      condition: item['weather'][0]['main'],
      icon: item['weather'][0]['icon'],
      humidity: item['main']['humidity'].toDouble(),
      windSpeed: item['wind']['speed'].toDouble(),
    )).take(7).toList();
  }

  Future<List<City>> searchCities(String query) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey'));
    final data = json.decode(response.body) as List;
    
    return data.map((item) => City(
      name: item['name'],
      country: item['country'],
      lat: item['lat'].toDouble(),
      lon: item['lon'].toDouble(),
    )).toList();
  }
}