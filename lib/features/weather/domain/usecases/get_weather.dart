import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/errors/failures.dart';
import 'package:weatherapp/core/params/params.dart';
import 'package:weatherapp/core/usecase/usecase.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';

class GetWeather implements UseCase<WeatherEntity, WeatherParams> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(WeatherParams params) async {
    return await repository.getWeather(params.city);
  }
}
