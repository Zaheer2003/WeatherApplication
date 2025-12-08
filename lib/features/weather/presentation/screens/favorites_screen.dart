import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/features/weather/presentation/providers/favorites_provider.dart';
import 'package:weatherapp/features/weather/presentation/screens/weather_screen.dart';
import 'package:weatherapp/widgets/glassmorphism.dart'; // Import GlassmorphicContainer

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        backgroundColor: Colors.transparent, // Inherit global background
        elevation: 0,
      ),
      body: favoritesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite cities added yet.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final city = favorites[index];
              return Container( // Added Container for margin
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 70, // Fixed height for list item
                  child: ListTile(
                    title: Text(
                      city,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white70),
                      onPressed: () {
                        ref
                            .read(favoritesNotifierProvider.notifier)
                            .removeFavorite(city);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WeatherScreen(city: city),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
