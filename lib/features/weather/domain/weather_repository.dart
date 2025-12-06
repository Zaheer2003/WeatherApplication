import 'weather_model.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
  Future<List<Forecast>> getForecast(String city);
}