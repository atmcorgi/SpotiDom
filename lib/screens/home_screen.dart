import 'package:flutter/material.dart';
import 'package:weather_music_app/services/get_spotify_acess_token_service.dart';
import 'package:weather_music_app/services/spotify_service.dart';
import 'package:weather_music_app/services/weather_service.dart';
import 'package:weather_music_app/widgets/control_panel_widget.dart';
import 'package:weather_music_app/widgets/footer_widget.dart';
import 'package:weather_music_app/widgets/header_widget.dart';
import 'package:weather_music_app/widgets/music_by_mood_widget.dart';
import 'package:weather_music_app/widgets/popular_tracks_widget.dart';
import 'package:weather_music_app/widgets/suggested_tracks_widget.dart';
import 'package:weather_music_app/widgets/title_widget.dart';
import 'package:weather_music_app/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final weatherService = WeatherService();
  late Future<Map<String, dynamic>> weatherData;
  Future<List<Map<String, dynamic>>>? _suggestedListFuture;

  late SpotifyService _spotifyService;
  late SpotifyAuthService _authService;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _authService = SpotifyAuthService(
      clientId: '9ee1c645cf9b47b880227a3c4456e00d',
      clientSecret: '2dbdf3c5369244bbafb88242773af528',
      redirectUri: 'http://localhost:8080/callback',
    );
    fetchToken();
    weatherData = weatherService.fetchWeather('Hanoi');
  }

  void fetchToken() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      setState(() {
        _accessToken = token;
        _spotifyService = SpotifyService(_accessToken!);
      });
      _suggestedListFuture = _spotifyService.fetchRecommendations();
      setState(() {});
    } else {
      print('Cannot get access token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return WeatherWidget(weatherData: snapshot.data!);
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ListView(children: [
                      CustomTitle(title: 'Suggested For You'),
                      if (_suggestedListFuture != null)
                        SuggestedTracksWidget(
                          tracksList: _suggestedListFuture!,
                        )
                      else
                        Center(child: CircularProgressIndicator()),
                      CustomTitle(title: 'Popular Tracks'),
                      if (_suggestedListFuture != null)
                        PopularTracksWidget(
                          popularTracks: _suggestedListFuture!,
                        )
                      else
                        Center(child: CircularProgressIndicator()),
                      CustomTitle(title: 'Music by Mood'),
                      if (_suggestedListFuture != null)
                        MusicByMoodWidget(
                          tracksList: _suggestedListFuture!,
                          spotifyService: _spotifyService,
                        )
                      else
                        Center(child: CircularProgressIndicator()),
                    ]),
                  ),
                ),
              ),
              Footer(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: _accessToken != null
                ? ControlPanel(spotifyService: _spotifyService)
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
