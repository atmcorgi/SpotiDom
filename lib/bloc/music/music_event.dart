import 'package:SpotiDom/data/models/weather.dart';
import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class FetchMusicByWeather extends MusicEvent {
  final Weather weather;

  const FetchMusicByWeather(this.weather);

  @override
  List<Object> get props => [weather];
}

class PlayTrack extends MusicEvent {
  final String trackUri;

  const PlayTrack(this.trackUri);
}
