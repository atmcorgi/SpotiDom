import 'package:SpotiDom/constants/map_weather.dart';

class Weather {
  final String name;
  final String country;
  final double temperature;
  final String description;
  final String main;
  final String icon;
  final String musicDescription;

  Weather({
    required this.name,
    required this.country,
    required this.main,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.musicDescription,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    String weatherDescription = json['weather'][0]['description'];

    String mappedMusicDescription = weatherDescriptions[weatherDescription]
            ?['description'] ??
        'No description available';

    return Weather(
      name: json['name'],
      country: json['sys']['country'],
      main: json['weather'][0]['main'],
      temperature: json['main']['temp'],
      description: weatherDescription,
      icon: json['weather'][0]['icon'],
      musicDescription: mappedMusicDescription,
    );
  }
}
