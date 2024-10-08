import 'package:SpotiDom/constants/map_weather.dart';

class Weather {
  final String name;
  final String country;
  final double temperature;
  final double feelsLike; // Nhiệt độ cảm nhận
  final String description;
  final String main;
  final String icon;
  final String musicDescription;
  final int humidity; // Độ ẩm
  final double windSpeed; // Tốc độ gió
  final double rainfall; // Lượng mưa trong 1 giờ

  Weather({
    required this.name,
    required this.country,
    required this.main,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.musicDescription,
    required this.humidity,
    required this.windSpeed,
    required this.rainfall,
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
      feelsLike: json['main']['feels_like'], // Nhiệt độ cảm nhận
      description: weatherDescription,
      icon: json['weather'][0]['icon'],
      musicDescription: mappedMusicDescription,
      humidity: json['main']['humidity'], // Độ ẩm
      windSpeed: json['wind']['speed'], // Tốc độ gió
      rainfall: json['rain']?['1h']?.toDouble() ??
          0.0, // Lượng mưa trong 1 giờ, mặc định là 0.0 nếu không có
    );
  }

  @override
  String toString() {
    return 'Weather:\n'
        'Name: $name\n'
        'Country: $country\n'
        'Main: $main\n'
        'Temperature: $temperature\n'
        'Feels Like: $feelsLike\n' // Nhiệt độ cảm nhận
        'Description: $description\n'
        'Icon: $icon\n'
        'Music Description: $musicDescription\n'
        'Humidity: $humidity%\n' // Độ ẩm
        'Wind Speed: $windSpeed m/s\n' // Tốc độ gió
        'Rainfall (last hour): $rainfall mm\n'; // Lượng mưa
  }
}
