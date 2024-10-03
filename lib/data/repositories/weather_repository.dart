import 'package:SpotiDom/data/models/weather.dart';
import 'package:SpotiDom/data/datasources/weather_api.dart';

class WeatherRepository {
  final WeatherApi weatherApi;

  WeatherRepository(this.weatherApi);

  Future<Weather> getWeatherByCity(String city) async {
    try {
      final data = await weatherApi.fetchWeather(city);
      return Weather.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get weather data');
    }
  }

  Future<Weather> getWeatherByLocation() async {
    try {
      final data = await weatherApi.fetchWeatherByLocation();
      return Weather.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get weather data');
    }
  }
}
