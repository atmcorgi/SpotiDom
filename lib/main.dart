import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';
import 'bloc/weather_bloc.dart'; // Thêm đường dẫn đến WeatherBloc của bạn

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(), // Khởi tạo WeatherBloc
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/search': (context) => SearchScreen(),
          '/library': (context) => LibraryScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}
