import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weatherapp/core/errors/exceptions.dart';
import 'package:weatherapp/features/weather/domain/weather_model.dart';

class WeatherApiService {
  final String apiKey = "11764c584cfd4a4d50a90683a0a39656";
  final String unit;

  WeatherApiService(this.unit);

  Future<Weather> fetchWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=$unit&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to load weather data',
          statusCode: response.statusCode,
        );
      }

      return Weather.fromJson(json.decode(response.body));
    } on SocketException {
      throw ServerException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0); // 0 can indicate no connection
    } on http.ClientException catch (e) {
      throw ServerException(
          message: 'Client error: ${e.message}',
          statusCode: 0); // 0 can indicate client-side error
    } catch (e) {
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 0);
    }
  }

  Future<List<Forecast>> fetchForecast(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$unit&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to load forecast data',
          statusCode: response.statusCode,
        );
      }

      final data = json.decode(response.body);
      final list = data['list'] as List;

      return list.map((item) => Forecast.fromJson(item)).toList();
    } on SocketException {
      throw ServerException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0);
    } on http.ClientException catch (e) {
      throw ServerException(
          message: 'Client error: ${e.message}',
          statusCode: 0);
    } catch (e) {
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 0);
    }
  }
}