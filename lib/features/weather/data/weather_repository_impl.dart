import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/errors/failures.dart';
import 'package:weatherapp/features/weather/domain/entities/forecast_entity.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:weatherapp/features/weather/domain/weather_model.dart';
import 'weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService api;

  WeatherRepositoryImpl(this.api);

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String city) async {
    try {
      final weather = await api.fetchWeather(city);
      return Right(WeatherEntity(
        cityName: weather.cityName,
        description: weather.description,
        temperature: weather.temperature,
        feelsLike: weather.feelsLike,
        tempMin: 0, // tempMin and tempMax not in Weather model, using defaults
        tempMax: 0,
        humidity: weather.humidity,
        windSpeed: weather.windSpeed,
        pressure: weather.pressure,
        sunrise: weather.sunrise,
        sunset: weather.sunset,
        alerts: weather.alerts,
        dt: 0, // dt not in Weather model, using default
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForecastEntity>> getWeatherForecast(String city) async {
    try {
      final forecastList = await api.fetchForecast(city);
      final weatherEntityList = forecastList.map((forecast) {
        return WeatherEntity(
          cityName: '', // Not available in Forecast model
          description: forecast.description,
          temperature: forecast.temperature,
          feelsLike: 0, // Not available in Forecast model
          tempMin: 0, // Not available in Forecast model
          tempMax: 0, // Not available in Forecast model
          humidity: 0, // Not available in Forecast model
          windSpeed: 0, // Not available in Forecast model
          pressure: 0, // Not available in Forecast model
          sunrise: DateTime.now(), // Not available in Forecast model
          sunset: DateTime.now(), // Not available in Forecast model
          alerts: [], // Not available in Forecast model
          dt: forecast.date.millisecondsSinceEpoch,
        );
      }).toList();
      return Right(ForecastEntity(forecastList: weatherEntityList));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}