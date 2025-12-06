import '../domain/weather_model.dart';
import '../domain/weather_repository.dart';
import 'weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService api;

  WeatherRepositoryImpl(this.api);

  @override
  Future<Weather> getWeather(String city) async {
    return await api.fetchWeather(city);
  }

  @override
  Future<List<Forecast>> getForecast(String city) async {
    return await api.fetchForecast(city);
  }
}