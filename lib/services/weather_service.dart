import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_music_app/config.dart';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$weatherApiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherByLocation(
      double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
