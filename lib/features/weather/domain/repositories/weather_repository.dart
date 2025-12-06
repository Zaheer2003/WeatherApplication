import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/errors/failures.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(String city);
}
