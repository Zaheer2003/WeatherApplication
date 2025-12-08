import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:weatherapp/features/weather/domain/entities/forecast_entity.dart';

class ForecastModel extends ForecastEntity {
  const ForecastModel({required List<WeatherModel> forecastList})
      : super(forecastList: forecastList);

  factory ForecastModel.fromJson(List<dynamic> jsonList) {
    return ForecastModel(
      forecastList:
          jsonList.map((json) => WeatherModel.fromJson(json)).toList(),
    );
  }
}
