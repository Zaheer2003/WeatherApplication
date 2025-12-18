import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/weather_viewmodel.dart';

final weatherProvider = StateNotifierProvider<WeatherViewModel, WeatherState>((ref) {
  return WeatherViewModel();
});