// music_control_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Định nghĩa sự kiện
abstract class MusicControlEvent {}

class TrackSelectedEvent extends MusicControlEvent {
  final String trackUri;

  TrackSelectedEvent(this.trackUri);
}

// Định nghĩa trạng thái
abstract class MusicControlState {}

class MusicControlInitialState extends MusicControlState {}

class MusicControlUpdatedState extends MusicControlState {
  final String trackUri;

  MusicControlUpdatedState(this.trackUri);
}

// Định nghĩa BLoC
class MusicControlBloc extends Bloc<MusicControlEvent, MusicControlState> {
  MusicControlBloc() : super(MusicControlInitialState());

  Stream<MusicControlState> mapEventToState(MusicControlEvent event) async* {
    if (event is TrackSelectedEvent) {
      yield MusicControlUpdatedState(event.trackUri);
    }
  }
}
