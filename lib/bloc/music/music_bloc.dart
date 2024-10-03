import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/music/music_event.dart';
import 'package:SpotiDom/bloc/music/music_state.dart';
import 'package:SpotiDom/data/repositories/music_repository.dart';
import 'package:SpotiDom/constants/map_weather.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository musicRepository;

  MusicBloc(this.musicRepository) : super(MusicLoading()) {
    on<FetchMusicByWeather>(_onFetchMusicByWeather);
    on<PlayTrack>(_onPlayTrack);
  }

  Future<void> _onFetchMusicByWeather(
    FetchMusicByWeather event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());

    try {
      // Lấy thông tin nhạc dựa trên điều kiện thời tiết
      final weatherDescription = weatherDescriptions[event.weatherCondition];

      if (weatherDescription != null) {
        final genres = weatherDescription['genres'] as List<String>;
        final minEnergy = weatherDescription['min_energy'] as double;
        final maxEnergy = weatherDescription['max_energy'] as double;
        final targetEnergy = weatherDescription['target_energy'] as double;
        final minValence = weatherDescription['min_valence'] as double;
        final targetValence = weatherDescription['target_valence'] as double;

        // Gọi API Spotify để lấy danh sách nhạc
        final recommendations = await musicRepository.getRecommendations(
          minEnergy: minEnergy,
          maxEnergy: maxEnergy,
          targetEnergy: targetEnergy,
          minValence: minValence,
          targetValence: targetValence,
          genres: genres,
        );

        if (recommendations.isNotEmpty) {
          emit(MusicLoaded(recommendations));
        } else {
          emit(MusicError('Không tìm thấy bài hát phù hợp'));
        }
      } else {
        emit(MusicError('Không tìm thấy nhạc cho điều kiện thời tiết này'));
      }
    } catch (error) {
      emit(MusicError('Lỗi khi lấy nhạc: $error'));
    }
  }

  // Xử lý sự kiện PlayTrack nhưng không thay đổi trạng thái
  Future<void> _onPlayTrack(
    PlayTrack event,
    Emitter<MusicState> emit,
  ) async {
    try {
      // Phát bài hát, không cần emit trạng thái mới
      await musicRepository.playTrack(trackUri: event.trackUri);
    } catch (error) {
      print('Error playing track: $error');
      // Bạn có thể phát ra lỗi nếu muốn, nhưng để giữ UI không thay đổi, bỏ qua emit
    }
  }
}
