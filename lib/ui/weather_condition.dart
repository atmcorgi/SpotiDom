import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_event.dart';
import 'package:SpotiDom/bloc/weather/weather_state.dart';
import 'package:SpotiDom/constants/map_weather.dart';
import 'package:SpotiDom/data/models/weather.dart';

class WeatherCondition extends StatefulWidget {
  final Weather weather;

  const WeatherCondition({super.key, required this.weather});

  @override
  _WeatherConditionState createState() => _WeatherConditionState();
}

class _WeatherConditionState extends State<WeatherCondition>
    with SingleTickerProviderStateMixin {
  String? selectedCity;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Thời gian chạy animation
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getBackgroundImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return 'images/clear.jpg';
      case 'clouds':
        return 'images/clouds.jpg';
      case 'drizzle':
        return 'images/drizzle.jpg';
      case 'rain':
        return 'images/rain.jpg';
      case 'thunderstorm':
        return 'images/thunderstorm.jpg';
      case 'snow':
        return 'images/snow.jpg';
      case 'mist':
        return 'images/mist.jpeg';
      case 'smoke':
        return 'images/smoke.jpg';
      case 'haze':
        return 'images/haze.jpeg';
      case 'dust':
        return 'images/dust.jpg';
      case 'fog':
        return 'images/fog.jpeg';
      case 'sand':
        return 'images/sand.jpeg';
      case 'ash':
        return 'images/ash.jpg';
      case 'squall':
        return 'images/squall.jpeg';
      case 'tornado':
        return 'images/tornado.jpg';
      default:
        return 'images/default_background.png'; // Hình nền mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          final weather = state.weather;
          final backgroundImage = getBackgroundImage(weather.main);

          _controller.forward();

          return FadeTransition(
            opacity: _controller,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white38,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dropdown to select city
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text(
                        "Select City",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      value: selectedCity,
                      items: cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                          if (selectedCity != null) {
                            context
                                .read<WeatherBloc>()
                                .add(FetchWeatherByCity(selectedCity!));
                          }
                        });
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.black.withOpacity(0.7),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Weather information
                  _buildWeatherInfo(weather),
                ],
              ),
            ),
          );
        } else if (state is WeatherError) {
          return Center(
            child: Text(
              'Failed to load weather data: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return Container(); // Default case
      },
    );
  }

  Widget _buildWeatherInfo(Weather weather) {
    final musicDescription = weather.musicDescription;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weather.name}, ${weather.country}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ' 🌍 ${weather.temperature}°C',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://openweathermap.org/img/wn/${weather.icon}.png',
                width: 50,
                height: 50,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                weather.description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            musicDescription,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
