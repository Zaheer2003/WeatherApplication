import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/presentation/providers/weather_state_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${widget.city}'),
      ),
      body: Center(
        child: weatherState.isLoading
            ? const CircularProgressIndicator()
            : weatherState.weather != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weatherState.weather!.cityName,
                        style: const TextStyle(fontSize: 32),
                      ),
                      Text(
                        weatherState.weather!.description,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${weatherState.weather!.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ],
                  )
                : Text(weatherState.error ?? 'Unknown error'),
      ),
    );
  }
}

