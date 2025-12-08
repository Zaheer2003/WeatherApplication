import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/presentation/providers/favorites_provider.dart';
import 'package:weatherapp/features/weather/presentation/providers/weather_state_provider.dart';
import 'package:weatherapp/widgets/glassmorphism.dart';
import 'package:weatherapp/features/weather/presentation/screens/forecast_screen.dart'; // Import ForecastScreen

class WeatherScreen extends ConsumerStatefulWidget {
  final String city;

  const WeatherScreen({Key? key, required this.city}) : super(key: key);

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherNotifierProvider.notifier).getWeather(widget.city);
    });
  }

  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
        return Icons.cloud;
      case 'shower rain':
      case 'rain':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit; // Changed to ac_unit for a more distinct snow icon
      case 'mist':
      case 'haze': // Added haze
      case 'fog': // Added fog
        return Icons.foggy;
      default:
        return Icons.cloud_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);
    final favoritesState = ref.watch(favoritesNotifierProvider);

    final isFavorite = favoritesState.maybeWhen(
      data: (favorites) => favorites.contains(widget.city),
      orElse: () => false,
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C1421), // from-blue-950
            Color(0xFF083344), // via-cyan-900
            Color(0xFF020617), // to-slate-950
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Weather in ${widget.city}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.white,
              ),
              onPressed: () {
                ref
                    .read(favoritesNotifierProvider.notifier)
                    .toggleFavorite(widget.city);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Builder(builder: (context) {
                if (weatherState.isLoading) {
                  return const CircularProgressIndicator();
                } else if (weatherState.weather != null) {
                  return GlassmorphicContainer(
                    width: MediaQuery.of(context).size.width * 0.8,
                                            height: 450,                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _getWeatherIcon(weatherState.weather!.description),
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            weatherState.weather!.cityName,
                            style: const TextStyle(
                                fontSize: 32, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weatherState.weather!.description,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${weatherState.weather!.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                                fontSize: 48, color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _WeatherDetail(
                                icon: Icons.water_drop_outlined,
                                label: 'Humidity',
                                value: '${weatherState.weather!.humidity}%',
                              ),
                              _WeatherDetail(
                                icon: Icons.air,
                                label: 'Wind Speed',
                                value: '${weatherState.weather!.windSpeed} m/s',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24), // Added spacing for button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ForecastScreen(city: weatherState.weather!.cityName),
                                ),
                              );
                            },
                            child: const Text('View 5-Day Forecast'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Text(
                    weatherState.error ?? 'Unknown error',
                    style: const TextStyle(color: Colors.white),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
