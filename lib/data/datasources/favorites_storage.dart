import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/city.dart';

class FavoritesStorage {
  static const String _key = 'favorite_cities';

  Future<List<City>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_key);
      if (data == null || data.isEmpty) return [];
      
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => City(
        name: json['name'],
        country: json['country'],
        lat: json['lat'].toDouble(),
        lon: json['lon'].toDouble(),
      )).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveFavorites(List<City> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(cities.map((city) => {
      'name': city.name,
      'country': city.country,
      'lat': city.lat,
      'lon': city.lon,
    }).toList());
    await prefs.setString(_key, data);
  }
}