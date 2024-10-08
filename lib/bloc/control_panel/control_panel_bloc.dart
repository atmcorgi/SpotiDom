import 'package:SpotiDom/bloc/control_panel/control_panel_event.dart';
import 'package:SpotiDom/data/datasources/spotify_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_state.dart';
import 'package:SpotiDom/data/repositories/music_repository.dart';

class ControlPanelBloc extends Bloc<ControlPanelEvent, ControlPanelState> {
  final SpotifyApi _spotifyApi; // Sử dụng Spotify API
  final MusicRepository musicRepository;

  ControlPanelBloc(this._spotifyApi, this.musicRepository)
      : super(ControlPanelState()) {
    on<PlayTrackInControlPanel>((event, emit) async {
      // Gọi API để phát bài hát và cập nhật trạng thái
      try {
        await musicRepository.playTrack(trackUri: event.trackUri);

        emit(state.copyWith(
          trackUri: event.trackUri,
          trackName: event.trackName,
          artistName: event.artistName,
          albumImageUrl: event.albumImageUrl,
          isPlaying: true,
        ));
      } catch (e) {
        // Xử lý lỗi khi không thể phát bài hát
      }
    });

    on<PauseTrack>((event, emit) async {
      // Gọi API để tạm dừng bài hát và cập nhật trạng thái
      try {
        await _spotifyApi.pausePlayback();

        emit(state.copyWith(isPlaying: false));
      } catch (e) {
        // Xử lý lỗi khi không thể tạm dừng bài hát
      }
    });

    on<ResumeTrack>((event, emit) async {
      try {
        final trackInfo = await _spotifyApi.getCurrentlyPlayingTrack();

        if (trackInfo != null) {
          int positionMs = trackInfo['progress_ms'] ?? 0;
          int position = trackInfo['item'] != null &&
                  trackInfo['item']['track_number'] != null
              ? trackInfo['item']['track_number'] - 1
              : 0;

          if (trackInfo['context'] != null &&
              trackInfo['context']['uri'] != null) {
            await _spotifyApi.startOrResumePlayback(
                trackInfo['context']['uri'], position,
                positionMs: positionMs);
          } else {
            String context =
                'spotify:album:${trackInfo['item']['album']['id']}';
            await _spotifyApi.startOrResumePlayback(context, position,
                positionMs: positionMs);
          }

          // Cập nhật trạng thái trong Bloc
          emit(state.copyWith(isPlaying: true));
        }
      } catch (e) {
        //
      }
    });

    on<StopTrack>((event, emit) {
      // Khi dừng bài hát, cập nhật trạng thái
      emit(ControlPanelState());
    });

    // Next Track Event
    on<NextTrack>((event, emit) async {
      try {
        await _spotifyApi.skipToNext();
        final trackInfo = await _spotifyApi.getCurrentlyPlayingTrack();
        if (trackInfo != null) {
          emit(state.copyWith(
            trackUri: trackInfo['item']['uri'],
            trackName: trackInfo['item']['name'],
            artistName: trackInfo['item']['artists'][0]['name'],
            albumImageUrl: trackInfo['item']['album']['images'][0]['url'],
            isPlaying: true,
          ));
        }
      } catch (e) {
        // Handle next track error
      }
    });

    // Previous Track Event
    on<PreviousTrack>((event, emit) async {
      try {
        await _spotifyApi.skipToPrevious();
        final trackInfo = await _spotifyApi.getCurrentlyPlayingTrack();
        if (trackInfo != null) {
          emit(state.copyWith(
            trackUri: trackInfo['item']['uri'],
            trackName: trackInfo['item']['name'],
            artistName: trackInfo['item']['artists'][0]['name'],
            albumImageUrl: trackInfo['item']['album']['images'][0]['url'],
            isPlaying: true,
          ));
        }
      } catch (e) {
        // Handle previous track error
      }
    });
  }
}
