import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/errors/failures.dart';
import 'package:weatherapp/core/params/params.dart';
import 'package:weatherapp/core/usecase/usecase.dart';
import 'package:weatherapp/features/weather/domain/entities/forecast_entity.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';

class GetWeatherForecast implements UseCase<ForecastEntity, WeatherParams> {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  @override
  Future<Either<Failure, ForecastEntity>> call(WeatherParams params) async {
    return await repository.getWeatherForecast(params.city);
  }
}
