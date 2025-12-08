import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart';

class ForecastEntity extends Equatable {
  final List<WeatherEntity> forecastList;

  const ForecastEntity({required this.forecastList});

  @override
  List<Object?> get props => [forecastList];
}
