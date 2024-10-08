// ignore_for_file: avoid_print

import 'package:SpotiDom/bloc/control_panel/control_panel_bloc.dart';
import 'package:SpotiDom/bloc/search/search_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_event.dart';
import 'package:SpotiDom/data/datasources/get_spotify_acess_token_service.dart';
import 'package:SpotiDom/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/constants/string.dart';
import 'package:SpotiDom/ui/home_screen.dart';
import 'data/datasources/weather_api.dart';
import 'data/repositories/weather_repository.dart';
import 'data/datasources/spotify_api.dart';
import 'data/repositories/music_repository.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Gemini.init(apiKey: geminiApi);

  // Khởi tạo SpotifyAuthService để lấy access token
  final spotifyAuthService = SpotifyAuthService(
    clientId: clientId,
    clientSecret: clientSecret,
    redirectUri: redirectUri,
  );

  // Lấy access token
  String? accessToken;

  try {
    accessToken = await spotifyAuthService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Không thể lấy access token');
    }
  } catch (error) {
    print('Lỗi: $error');
    return;
  }

  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String accessToken;

  const MyApp({super.key, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WeatherRepository(WeatherApi()),
        ),
        RepositoryProvider(
          create: (context) => MusicRepository(
            SpotifyApi(accessToken),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false, // Khởi tạo ngay từ đầu và giữ lại trong suốt ứng dụng
            create: (context) => WeatherBloc(
              RepositoryProvider.of<WeatherRepository>(context),
            )..add(FetchWeatherByLocation()),
          ),
          BlocProvider(
            lazy:
                false, // Giữ lại ControlPanelBloc trong suốt thời gian ứng dụng chạy
            create: (context) => ControlPanelBloc(
              SpotifyApi(accessToken),
              RepositoryProvider.of<MusicRepository>(context),
            ),
          ),
          BlocProvider(
            lazy:
                false, // Giữ lại SearchBloc trong suốt thời gian ứng dụng chạy
            create: (context) => SearchBloc(
              SpotifyApi(accessToken),
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/search': (context) => SearchScreen(),
            // '/library': (context) => LibraryScreen(),
            // '/profile': (context) => ProfileScreen(),
          },
        ),
      ),
    );
  }
}
