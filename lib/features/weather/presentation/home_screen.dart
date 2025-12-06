import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/app/providers.dart';

class HomeScreen extends ConsumerWidget {
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Weather App',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 40),
              TextField(
                controller: cityController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter City Name",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  final city = cityController.text.trim();
                  if (city.isNotEmpty) {
                    ref.read(cityProvider.notifier).state = city;
                    context.go("/weather");
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final city = cityController.text.trim();
                  if (city.isNotEmpty) {
                    ref.read(cityProvider.notifier).state = city;
                    context.go("/weather");
                  }
                },
                child: Text("Get Weather", style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}



