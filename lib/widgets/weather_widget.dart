import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_music_app/services/weather_service.dart';
import 'package:weather_music_app/const.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService weatherService = WeatherService();
  String? selectedCity;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

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
    return Stack(
      children: [
        // Nội dung hiển thị của widget khi dữ liệu đã sẵn sàng
        Opacity(
          opacity: isLoading ? 0.5 : 1, // Tạo độ mờ khi đang tải dữ liệu
          child: _buildWeatherContent(),
        ),
        // Nếu đang tải thì hiển thị spinner ở giữa
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildWeatherContent() {
    String currentWeatherCondition =
        weatherData?['weather'][0]['main'] ?? 'default';
    String backgroundImage = getBackgroundImage(currentWeatherCondition);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
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
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey),
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
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black54,
              ),
              dropdownColor: Colors.black.withOpacity(.7),
              style: TextStyle(color: Colors.black),
            ),
          ),

          SizedBox(height: 20),
          // Hiển thị thông tin thời tiết
          weatherData != null
              ? _buildWeatherInfo(weatherData!)
              : Text('Không có dữ liệu thời tiết'),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(Map<String, dynamic> data) {
    final cityName = data['name'] != null
        ? data['name'] + ', ' + (data['sys']['country'] ?? '')
        : 'Unknown Location';
    final temperature = data['main'] != null && data['main']['temp'] != null
        ? data['main']['temp'].toString()
        : 'N/A';
    final weatherDescription =
        data['weather'] != null && data['weather'].isNotEmpty
            ? data['weather'][0]['description'] ?? 'No description'
            : 'No description';
    final weatherIcon = data['weather'] != null && data['weather'].isNotEmpty
        ? data['weather'][0]['icon'] ?? ''
        : '';

    final musicDescription =
        weatherDescriptions[weatherDescription]?['description'] ?? '';
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$cityName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ' 🌍 $temperature°C',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
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
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
