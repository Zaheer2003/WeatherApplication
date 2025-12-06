import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/app/providers.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUnit = ref.watch(temperatureUnitProvider);

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text('Temperature Unit', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              trailing: DropdownButton<String>(
                value: currentUnit,
                dropdownColor: Colors.black.withOpacity(0.7),
                style: TextStyle(color: Colors.white, fontSize: 18),
                items: [
                  DropdownMenuItem(
                    value: 'metric',
                    child: Text('Celsius'),
                  ),
                  DropdownMenuItem(
                    value: 'imperial',
                    child: Text('Fahrenheit'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(temperatureUnitProvider.notifier).state = value;
                  }
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


