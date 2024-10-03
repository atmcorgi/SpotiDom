abstract class WeatherEvent {}

class FetchWeatherByCity extends WeatherEvent {
  final String city;

  FetchWeatherByCity(this.city);
}

class FetchWeatherByLocation extends WeatherEvent {
  FetchWeatherByLocation();
}
