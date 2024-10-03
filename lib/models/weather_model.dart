class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeed;
  final int humidity;
  final int pressure;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });

  // Factory method to create WeatherModel from JSON data
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
    );
  }

  // Optionally, you can add a method to display weather info as a string
  @override
  String toString() {
    return 'Weather in $cityName: $description, Temp: $temperature°C, Wind: $windSpeed m/s, Humidity: $humidity%, Pressure: $pressure hPa';
  }
}
