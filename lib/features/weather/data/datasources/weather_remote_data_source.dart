import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/core/constants/api_endpoints.dart';
import 'package:weatherapp/core/errors/exceptions.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather(String city) async {
    final response = await dio.get(
      '${dotenv.env['BASE_URL']}${ApiEndpoints.current}',
      queryParameters: {
        'q': city,
        'appid': dotenv.env['API_KEY'],
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
