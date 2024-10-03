import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class FetchMusicByWeather extends MusicEvent {
  final String weatherCondition;

  const FetchMusicByWeather(this.weatherCondition);

  @override
  List<Object> get props => [weatherCondition];
}

class PlayTrack extends MusicEvent {
  final String trackUri;

  PlayTrack(this.trackUri);
}
