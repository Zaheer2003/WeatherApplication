import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/app/providers.dart';
import 'package:weatherapp/features/weather/domain/weather_model.dart';
import 'package:weatherapp/features/weather/presentation/settings_screen.dart';
import 'package:weatherapp/widgets/glassmorphism.dart';

class WeatherScreen extends ConsumerWidget {
  String _getBackgroundImage(String description) {
    if (description.contains('clear')) {
      return 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    } else if (description.contains('clouds')) {
      return 'https://images.unsplash.com/photo-1501630834273-4b5604d2ee31?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    } else if (description.contains('rain')) {
      return 'https://images.unsplash.com/photo-1515694346937-94d85e41e682?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    } else if (description.contains('snow')) {
      return 'https://images.unsplash.com/photo-1517299321609-52485ae3c383?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    } else {
      return 'https://images.unsplash.com/photo-1580193769210-b8d1c049a7d9?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final forecastAsync = ref.watch(forecastProvider);
    final city = ref.watch(cityProvider);
    final isFavoriteAsync = ref.watch(isFavoriteProvider);
    final unit = ref.watch(temperatureUnitProvider);
    final unitSymbol = unit == 'metric' ? '°C' : '°F';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(city, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          isFavoriteAsync.when(
            loading: () => IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: null),
            error: (err, _) => IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: null),
            data: (isFavorite) => IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
              onPressed: () async {
                final favoritesRepository = ref.read(favoritesRepositoryProvider);
                if (isFavorite) {
                  await favoritesRepository.removeFavorite(city);
                } else {
                  await favoritesRepository.addFavorite(city);
                }
                ref.refresh(favoritesProvider);
                ref.refresh(isFavoriteProvider);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.white),
            onPressed: () async {
              try {
                final locationService = ref.read(locationServiceProvider);
                final currentCity = await locationService.getCity();
                ref.read(cityProvider.notifier).state = currentCity;
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ],
      ),
      body: weatherAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: ${err.toString()}", style: TextStyle(color: Colors.white))),
        data: (weather) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_getBackgroundImage(weather.description)),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                GlassmorphicContainer(
                  width: 300,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(weather.cityName, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 10),
                      Text("${weather.temperature.toStringAsFixed(1)}$unitSymbol", style: TextStyle(fontSize: 50, color: Colors.white)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network("http://openweathermap.org/img/wn/${weather.icon}@2x.png"),
                          Text(weather.description, style: TextStyle(fontSize: 24, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Text("5-Day Forecast", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Expanded(
                  child: forecastAsync.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text("Error: ${err.toString()}", style: TextStyle(color: Colors.white))),
                    data: (forecasts) {
                      final dailyForecasts = _getDailyForecasts(forecasts);
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dailyForecasts.length,
                        itemBuilder: (context, index) {
                          final forecast = dailyForecasts[index];
                          return InkWell(
                            onTap: () {
                              final hourlyForecasts = forecasts
                                  .where((f) => DateFormat('yyyy-MM-dd').format(f.date) == DateFormat('yyyy-MM-dd').format(forecast.date))
                                  .toList();
                              context.go('/hourly-forecast', extra: hourlyForecasts);
                            },
                            child: GlassmorphicContainer(
                              width: 150,
                              height: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(DateFormat('EEE').format(forecast.date), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Image.network("http://openweathermap.org/img/wn/${forecast.icon}@2x.png"),
                                  Text("${forecast.temperature.toStringAsFixed(1)}$unitSymbol", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Forecast> _getDailyForecasts(List<Forecast> forecasts) {
    final dailyForecasts = <Forecast>[];
    final uniqueDates = <String>{};

    for (final forecast in forecasts) {
      final date = DateFormat('yyyy-MM-dd').format(forecast.date);
      if (dailyForecasts.length < 5 && !uniqueDates.contains(date)) {
        uniqueDates.add(date);
        dailyForecasts.add(forecast);
      }
    }

    return dailyForecasts;
  }
}