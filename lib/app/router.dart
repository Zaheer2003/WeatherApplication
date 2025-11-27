import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/weather/presenatation/home_screen.dart';
import '../features/weather/presenatation/weather_screen.dart';

final router = GoRouter(
    routes: [
        GoRoute(
            path:'/',
            builder:(context, state) => HomeScreen(),
        ),

        GoRoute(
            path:'/weather',
            builder:(context, state) {
                final city = state.uri.queryParameters['city'];
                return WeatherScreen(city: city!);
            }
        )
    ]
)