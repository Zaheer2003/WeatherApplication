import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/errors/exceptions.dart';
import 'package:weatherapp/core/errors/failures.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String city) async {
    try {
      final remoteWeather = await remoteDataSource.getWeather(city);
      return Right(remoteWeather);
    } on ServerException {
      return Left(ServerFailure('Server Failure'));
    }
  }
}
