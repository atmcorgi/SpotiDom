import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin từ weatherData
    final cityName = weatherData['name'] + ', ' + weatherData['sys']['country'];
    final temperature = weatherData['main']['temp'];
    final weatherDescription = weatherData['weather'][0]['description'];
    final weatherIcon = weatherData['weather'][0]['icon'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: const AssetImage(
              'assets/images/default-background.jpg'), // Hình nền mặc định
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2), // Điều chỉnh opacity tại đây
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tên thành phố
          Text(
            cityName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          // Nhiệt độ
          Text(
            '$temperature°C',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          // Thời tiết
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Biểu tượng thời tiết
              Image.network(
                'https://openweathermap.org/img/wn/$weatherIcon.png',
                width: 50,
                height: 50,
                color: Colors.white, // Tạo màu trắng cho biểu tượng thời tiết
              ),
              SizedBox(width: 8),
              // Mô tả thời tiết
              Text(
                weatherDescription,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
