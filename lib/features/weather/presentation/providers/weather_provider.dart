import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_weather.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => WeatherRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
  ),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    remoteDataSource: ref.watch(weatherRemoteDataSourceProvider),
  ),
);

final getWeatherProvider = Provider<GetWeather>(
  (ref) => GetWeather(
    ref.watch(weatherRepositoryProvider),
  ),
);
