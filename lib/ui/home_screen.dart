import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_event.dart';
import 'package:SpotiDom/bloc/weather/weather_state.dart';
import 'package:SpotiDom/data/repositories/weather_repository.dart';
import 'package:SpotiDom/ui/suggest_music_system.dart';
import 'package:SpotiDom/ui/weather_condition.dart';
import 'package:SpotiDom/widgets/footer_widget.dart';
import 'package:SpotiDom/widgets/header_widget.dart';
import 'package:SpotiDom/widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Stack(
        children: [
          BlocProvider(
            create: (context) => WeatherBloc(
              RepositoryProvider.of<WeatherRepository>(context),
            )..add(FetchWeatherByLocation()),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherLoaded) {
                  final weather = state.weather;
                  return Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        WeatherCondition(weather: weather),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.music_note,
                                size: 24, color: Colors.blue),
                            const SizedBox(width: 8),
                            CustomTitle(title: 'Based on your mood'),
                          ],
                        ),
                        Expanded(
                          child: SuggestMusicSystem(weather: weather),
                        ),
                      ],
                    ),
                  );
                } else if (state is WeatherError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
