import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_music_app/services/weather_service.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService weatherService = WeatherService();
  String? selectedCity;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  final List<String> cities = ['Hanoi', 'London', 'New York', 'Tokyo', 'Paris'];

  // Bản đồ mô tả âm nhạc dựa trên điều kiện thời tiết
  final Map<String, String> weatherDescriptions = {
    'Clear': 'Nhạc: Vui tươi, năng lượng cao, dễ nhảy múa.',
    'Few Clouds': 'Nhạc: Vui vẻ, nhưng có chút nhẹ nhàng.',
    'Scattered Clouds':
        'Nhạc: Bình yên, thư giãn, đôi khi mang hơi hướng tươi sáng.',
    'Broken Clouds': 'Nhạc: Trầm lắng hơn, mang tính suy tư.',
    'Shower Rain': 'Nhạc: Cảm xúc, đôi chút sôi động nhưng ẩn chứa sự buồn bã.',
    'Rain': 'Nhạc: Chậm, u buồn, trầm mặc.',
    'Thunderstorm': 'Nhạc: Mạnh mẽ, kịch tính, năng lượng cao.',
    'Snow': 'Nhạc: Lãng mạn, ấm áp, nhẹ nhàng.',
    'Mist': 'Nhạc: Bí ẩn, trầm lắng, dễ gây suy tư.',
    'Smoke': 'Nhạc: Đen tối, ma mị, u ám.',
    'Haze': 'Nhạc: Nhẹ nhàng, thoải mái, không quá căng thẳng.',
    'Dust': 'Nhạc: Lạnh lùng, mạnh mẽ, đôi khi bí ẩn.',
    'Fog': 'Nhạc: Dịu dàng, nhẹ nhàng, nhưng có cảm giác mơ hồ.',
    'Sand': 'Nhạc: Sức mạnh, đầy năng lượng nhưng cũng mang chút bí ẩn.',
    'Ash': 'Nhạc: U tối, cảm xúc mạnh, đôi khi gợi cảm giác thất vọng.',
    'Squall': 'Nhạc: Năng lượng mạnh, kích thích cảm xúc mãnh liệt.',
    'Tornado': 'Nhạc: Cường độ cao, nhịp điệu nhanh, cảm xúc mãnh liệt.',
  };

  @override
  void initState() {
    super.initState();
    _fetchWeatherByCurrentLocation(); // Mặc định lấy vị trí hiện tại
  }

  Future<void> _fetchWeatherByCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      Position position = await _determinePosition();
      weatherData = await weatherService.fetchWeatherByLocation(
          position.latitude, position.longitude);
    } catch (e) {
      print('Failed to fetch weather by location: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
    });
    try {
      weatherData = await weatherService.fetchWeather(city);
    } catch (e) {
      print('Failed to fetch weather by city: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Dịch vụ định vị đã bị tắt.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        throw Exception('Quyền truy cập vị trí bị từ chối');
    }
    if (permission == LocationPermission.deniedForever)
      throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn.');

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0), // Padding cho toàn bộ widget
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              '/images/default-background.jpg'), // Đường dẫn đến ảnh trong assets
          fit: BoxFit.cover, // Làm cho ảnh phủ kín Container
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dropdown để chọn thành phố
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.transparent, // Nền của dropdown
              borderRadius: BorderRadius.circular(8), // Bo góc cho dropdown
              border:
                  Border.all(color: Colors.blueGrey), // Đường viền cho dropdown
            ),
            child: DropdownButton<String>(
              hint: Text(
                "Chọn thành phố",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              value: selectedCity,
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(
                    city,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                  if (selectedCity != null) {
                    _fetchWeatherByCity(selectedCity!);
                  }
                });
              },
              isExpanded: true, // Mở rộng dropdown để chiếm toàn bộ chiều rộng
              underline: SizedBox(), // Ẩn đường dưới của dropdown
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black54, // Màu sắc cho biểu tượng
              ),
              dropdownColor: Colors.transparent, // Màu nền cho menu dropdown
              style: TextStyle(color: Colors.black), // Màu chữ trong dropdown
            ),
          ),

          SizedBox(height: 20),
          // Hiển thị thông tin thời tiết
          isLoading
              ? CircularProgressIndicator()
              : weatherData != null
                  ? _buildWeatherInfo(weatherData!)
                  : Text('Không có dữ liệu thời tiết'),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(Map<String, dynamic> data) {
    final cityName = data['name'] + ', ' + data['sys']['country'];
    final temperature = data['main']['temp'];
    final weatherDescription = data['weather'][0]['description'];
    final weatherIcon = data['weather'][0]['icon'];
    final mainWeather = data['weather'][0]['main']; // Lấy tên thời tiết chính

    // Lấy mô tả âm nhạc từ bản đồ
    final musicDescription = weatherDescriptions[mainWeather] ?? '';
    print('MAIN: $mainWeather');
    print('DESC: $musicDescription');
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // Nền tối
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
                color: Colors.white,
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
          SizedBox(height: 8),
          // Hiển thị mô tả âm nhạc
          Text(
            musicDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
