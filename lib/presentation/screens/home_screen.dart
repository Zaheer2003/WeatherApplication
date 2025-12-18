import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import 'forecast_screen.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onSearchPressed;
  const HomeScreen({super.key, this.onSearchPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Weather', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search, size: 20),
            ),
            onPressed: onSearchPressed,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: weatherState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : weatherState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Error: ${weatherState.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: weatherNotifier.getCurrentLocationWeather,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : weatherState.currentWeather == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off, size: 64, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 16),
                          const Text('No weather data'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: weatherNotifier.getCurrentLocationWeather,
                            child: const Text('Get Location Weather'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: weatherNotifier.getCurrentLocationWeather,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Main weather card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    weatherState.currentWeather!.cityName,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${weatherState.currentWeather!.icon}@4x.png',
                                    height: 120,
                                  ),
                                  Text(
                                    '${weatherState.currentWeather!.temperature.round()}°C',
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    weatherState.currentWeather!.description.toUpperCase(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white70,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Weather details grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.5,
                              children: [
                                _buildWeatherCard(
                                  context,
                                  Icons.water_drop,
                                  'Humidity',
                                  '${weatherState.currentWeather!.humidity.round()}%',
                                ),
                                _buildWeatherCard(
                                  context,
                                  Icons.air,
                                  'Wind Speed',
                                  '${weatherState.currentWeather!.windSpeed.round()} m/s',
                                ),
                                _buildWeatherCard(
                                  context,
                                  Icons.compress,
                                  'Pressure',
                                  '${weatherState.currentWeather!.pressure.round()} hPa',
                                ),
                                _buildWeatherCard(
                                  context,
                                  Icons.wb_sunny,
                                  'Sunrise',
                                  '${weatherState.currentWeather!.sunrise.hour}:${weatherState.currentWeather!.sunrise.minute.toString().padLeft(2, '0')}',
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Forecast button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ForecastScreen()),
                                ),
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('7-Day Forecast'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: weatherNotifier.getCurrentLocationWeather,
        icon: const Icon(Icons.my_location),
        label: const Text('Refresh'),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, IconData icon, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}