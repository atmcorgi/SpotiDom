// ignore_for_file: library_private_types_in_public_api

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

  // Get background color based on weather condition
  Color getBackgroundColor(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Colors.lightBlueAccent.shade100; // Sáng, tươi tắn hơn
      case 'clouds':
        return Colors
            .blueGrey.shade400; // Xanh xám sáng, giữ được cảm giác đám mây
      case 'drizzle':
        return Colors.cyanAccent.shade200; // Màu xanh ngọc sáng, nhẹ nhàng
      case 'rain':
        return Colors.deepPurpleAccent.shade200; // Tím sáng, năng động
      case 'thunderstorm':
        return Colors.purpleAccent.shade400; // Tím rực rỡ, kịch tính
      case 'snow':
        return Colors
            .lightBlue.shade200; // Xanh nhạt tạo cảm giác trong trẻo hơn trắng
      case 'mist':
        return Colors.cyan.shade200; // Xanh dịu nhẹ, phù hợp với sương mờ
      case 'smoke':
        return Colors
            .deepOrangeAccent.shade200; // Cam sáng, mạnh mẽ thay vì xám
      case 'haze':
        return Colors
            .amberAccent.shade200; // Vàng sáng hơn, vẫn giữ cảm giác ấm áp
      case 'dust':
        return Colors.orangeAccent.shade200; // Cam sáng và ấm áp hơn
      case 'fog':
        return Colors.cyan.shade400; // Xanh ngọc sáng thay vì xám
      case 'sand':
        return Colors
            .yellowAccent.shade200; // Vàng nhạt, tươi sáng và hợp với nền tối
      case 'ash':
        return Colors.purple.shade300; // Tím sáng hơn cho cảm giác bí ẩn
      case 'squall':
        return Colors.tealAccent.shade200; // Xanh lá ánh sáng hơn
      case 'tornado':
        return Colors.redAccent.shade200; // Đỏ sáng, tạo ấn tượng mạnh
      default:
        return Colors
            .blueAccent.shade200; // Màu xanh thay vì đen để nổi bật hơn
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
          final backgroundColor =
              getBackgroundColor(weather.main); // Use background color

          _controller.forward();

          return FadeTransition(
            opacity: _controller,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blueGrey,
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
