import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class ForecastScreen extends ConsumerWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('7-Day Forecast')),
      body: ListView.builder(
        itemCount: weatherState.forecast.length,
        itemBuilder: (context, index) {
          final forecast = weatherState.forecast[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network('https://openweathermap.org/img/wn/${forecast.icon}@2x.png'),
              title: Text(DateFormat('EEEE, MMM d').format(forecast.date)),
              subtitle: Text(forecast.condition),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${forecast.maxTemp.round()}°/${forecast.minTemp.round()}°'),
                  Text('${forecast.humidity.round()}% • ${forecast.windSpeed.round()}m/s'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}