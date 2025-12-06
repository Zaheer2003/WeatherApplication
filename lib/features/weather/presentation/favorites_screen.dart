import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/app/providers.dart';

class FavoritesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      body: favoritesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}', style: TextStyle(color: Colors.white))),
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Text('You have no favorite cities yet.', style: TextStyle(color: Colors.white, fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final city = favorites[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(city, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  onTap: () {
                    ref.read(cityProvider.notifier).state = city;
                    context.go('/weather');
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () async {
                      await ref
                          .read(favoritesRepositoryProvider)
                          .removeFavorite(city);
                      ref.refresh(favoritesProvider);
                      ref.refresh(isFavoriteProvider);
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
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
