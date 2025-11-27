import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/weather/data/weather_api_service.dart';
import '../features/weather/data/weather_repository_impl.dart';

final weatherApiServiceProvider = Provider((ref) => WeatherApiService());

final weatherRepositoryPovider = Provider(
    (ref) => WeatherRepositoryImpl(
        ref.read(weatherApiServiceProvider),
    ),
);