import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/features/weather/domain/weather_model.dart';
import 'package:weatherapp/features/weather/presentation/hourly_forecast_screen.dart';
import 'package:weatherapp/features/weather/presentation/root_screen.dart';
import '../features/weather/presentation/weather_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => RootScreen(),
    ),
    GoRoute(
      path: '/weather',
      builder: (context, state) => WeatherScreen(),
    ),
    GoRoute(
      path: '/hourly-forecast',
      builder: (context, state) {
        final forecasts = state.extra as List<Forecast>;
        return HourlyForecastScreen(hourlyForecasts: forecasts);
      },
    ),
  ],
);