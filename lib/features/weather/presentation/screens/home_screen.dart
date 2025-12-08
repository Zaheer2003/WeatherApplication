import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/presentation/providers/search_history_provider.dart'; // Import search history provider
import 'package:weatherapp/features/weather/presentation/screens/weather_screen.dart';
import 'package:weatherapp/widgets/glassmorphism.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToWeatherScreen(String city) {
    if (city.isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).addCity(city); // Add to history
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WeatherScreen(city: city),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchHistory = ref.watch(searchHistoryProvider); // Watch the search history

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.8,
          height: searchHistory.isEmpty ? 200 : 350, // Adjust height based on history presence
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter city name',
                  ),
                  onSubmitted: _navigateToWeatherScreen, // Trigger search on submit
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _navigateToWeatherScreen(_controller.text),
                  child: const Text('Get Weather'),
                ),
                if (searchHistory.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Recent Searches', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        final city = searchHistory[index];
                        return ListTile(
                          title: Text(city, style: const TextStyle(color: Colors.white)),
                          leading: const Icon(Icons.history, color: Colors.white54),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white54),
                            onPressed: () {
                              ref.read(searchHistoryProvider.notifier).removeCity(city);
                            },
                          ),
                          onTap: () {
                            _controller.text = city;
                            _navigateToWeatherScreen(city);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
