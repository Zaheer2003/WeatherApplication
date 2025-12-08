import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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

  String _getWeatherIconAsset(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'assets/icons/clear-day.svg';
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
        return 'assets/icons/cloudy.svg';
      case 'shower rain':
      case 'rain':
        return 'assets/icons/rain.svg';
      case 'thunderstorm':
        return 'assets/icons/thunderstorms-day.svg';
      case 'snow':
        return 'assets/icons/snow.svg';
      case 'mist':
      case 'haze':
      case 'fog':
        return 'assets/icons/haze.svg';
      default:
        return 'assets/icons/cloudy.svg'; // Default to a general cloud icon
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
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
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
                  final weather = weatherState.weather!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weather.alerts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.redAccent.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.warning_amber_rounded, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('WEATHER ALERTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ...weather.alerts.map((alert) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      '${alert.event}: ${alert.description} (from ${alert.senderName})',
                                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                  )).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      GlassmorphicContainer(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 580, // Increased height for more details and potential alerts
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                _getWeatherIconAsset(weather.description),
                                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                    fontSize: 32, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                weather.description,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${weather.temperature.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                    fontSize: 48, color: Colors.white),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  children: [
                                    _WeatherDetail(
                                      icon: 'assets/icons/thermometer-celsius.svg',
                                      label: 'Feels Like',
                                      value: '${weather.feelsLike.toStringAsFixed(1)}°C',
                                    ),
                                    _WeatherDetail(
                                      icon: 'assets/icons/umbrella.svg',
                                      label: 'Humidity',
                                      value: '${weather.humidity}%',
                                    ),
                                    _WeatherDetail(
                                      icon: 'assets/icons/dust-wind.svg',
                                      label: 'Wind Speed',
                                      value: '${weather.windSpeed} m/s',
                                    ),
                                    _WeatherDetail(
                                      icon: 'assets/icons/barometer.svg',
                                      label: 'Pressure',
                                      value: '${weather.pressure} hPa',
                                    ),
                                    _WeatherDetail(
                                      icon: 'assets/icons/clear-day.svg',
                                      label: 'Sunrise',
                                      value: DateFormat('HH:mm').format(weather.sunrise),
                                    ),
                                    _WeatherDetail(
                                      icon: 'assets/icons/clear-night.svg',
                                      label: 'Sunset',
                                      value: DateFormat('HH:mm').format(weather.sunset),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForecastScreen(city: weather.cityName),
                                    ),
                                  );
                                },
                                child: const Text('View 5-Day Forecast'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
  final String icon;
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
        SvgPicture.asset(icon, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 24, height: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
