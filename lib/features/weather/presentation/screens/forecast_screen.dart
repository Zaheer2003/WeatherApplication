import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/features/weather/domain/entities/weather_entity.dart'; // Add this import
import 'package:weatherapp/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weatherapp/widgets/glassmorphism.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  final String city;

  const ForecastScreen({Key? key, required this.city}) : super(key: key);

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forecastNotifierProvider.notifier).getForecast(widget.city);
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
        return Icons.grain;
      case 'rain':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'haze':
      case 'fog':
        return Icons.foggy;
      default:
        return Icons.cloud_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final forecastState = ref.watch(forecastNotifierProvider);

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
          title: Text('5-Day Forecast for ${widget.city}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: forecastState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              'Error: ${err.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (forecast) {
            if (forecast.forecastList.isEmpty) {
              return const Center(
                child: Text(
                  'No forecast data available.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Group forecast data by date
            final Map<String, List<WeatherEntity>> dailyForecast = {};
            for (var item in forecast.forecastList) {
              final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
              final dateKey = DateFormat('yyyy-MM-dd').format(date);
              dailyForecast.putIfAbsent(dateKey, () => []).add(item);
            }

            return ListView.builder(
              itemCount: dailyForecast.keys.length,
              itemBuilder: (context, index) {
                final dateKey = dailyForecast.keys.elementAt(index);
                final dayForecasts = dailyForecast[dateKey]!;

                // Get average temperature for the day
                final avgTemp = dayForecasts.map((e) => e.temperature).reduce((a, b) => a + b) / dayForecasts.length;

                // Get most common description for the day
                final descriptionCounts = <String, int>{};
                for (var item in dayForecasts) {
                  descriptionCounts[item.description] = (descriptionCounts[item.description] ?? 0) + 1;
                }
                final commonDescription = descriptionCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;


                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          _getWeatherIcon(commonDescription),
                          color: Colors.white,
                          size: 40,
                        ),
                        title: Text(
                          DateFormat('EEEE, MMM d').format(DateTime.parse(dateKey)),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Text(
                          commonDescription,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          '${avgTemp.toStringAsFixed(1)}°C',
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}