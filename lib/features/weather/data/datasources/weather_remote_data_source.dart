import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/core/constants/api_endpoints.dart';
import 'package:weatherapp/core/errors/exceptions.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String city);
  Future<List<WeatherModel>> getWeatherForecast(String city);
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
      log('DioException caught: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<List<WeatherModel>> getWeatherForecast(String city) async {
    final url = '${dotenv.env['BASE_URL']}/${ApiEndpoints.forecast}';
    final queryParameters = {
      'q': city,
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
        final List<dynamic> forecastList = response.data['list'];
        return forecastList.map((json) => WeatherModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('DioException caught (Forecast): ${e.message}');
      rethrow;
    }
  }
}
