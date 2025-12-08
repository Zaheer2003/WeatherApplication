import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/core/constants/api_endpoints.dart';
import 'package:weatherapp/core/errors/exceptions.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String city);
  Future<Map<String, double>> getCoordinates(String city);
  Future<List<WeatherModel>> getWeatherForecast(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather(String city) async {
    final url = '${dotenv.env['BASE_URL']}/${ApiEndpoints.current}';
    final queryParameters = {
      'q': city,
      'appid': dotenv.env['API_KEY'],
      'units': 'metric',
    };

    log('Requesting URL: $url with params: $queryParameters');

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('DioException caught: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getCoordinates(String city) async {
    final url = '${dotenv.env['BASE_URL']}/${ApiEndpoints.geocoding}';
    final queryParameters = {
      'q': city,
      'limit': 1,
      'appid': dotenv.env['API_KEY'],
    };

    log('Requesting Coordinates URL: $url with params: $queryParameters');

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        final data = response.data[0];
        return {'lat': data['lat'], 'lon': data['lon']};
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('DioException caught (Coordinates): ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<WeatherModel>> getWeatherForecast(double lat, double lon) async {
    // Note: The One Call API endpoint is not yet in api_endpoints.dart
    // I will use a placeholder 'onecall' for now and add it later.
    final url = '${dotenv.env['BASE_URL']}/${ApiEndpoints.onecall}';
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'exclude': 'current,minutely,hourly,alerts',
      'appid': dotenv.env['API_KEY'],
      'units': 'metric',
    };

    log('Requesting Forecast URL: $url with params: $queryParameters');

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> forecastList = response.data['daily'];
        return forecastList.map((json) => WeatherModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('DioException caught (Forecast): ${e.toString()}');
      rethrow;
    }
  }
}
