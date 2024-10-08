// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/music/music_event.dart';
import 'package:SpotiDom/bloc/music/music_state.dart';
import 'package:SpotiDom/data/repositories/music_repository.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository musicRepository;
  final gemini = Gemini.instance;

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
      // Lấy thông tin thời tiết từ sự kiện
      // print(event.weather.toString());

      // Tạo prompt cho Gemini
      String prompt = '''
      Tôi dùng Flutter để call Spotify Web Api, ứng dụng của tôi dựa vào thông tin thời tiết để gợi ý nhạc phù hợp. Dựa vào các thông tin sau:
      - Thành phố: ${event.weather.name}
      - Quốc gia: ${event.weather.country}
      - Nhiệt độ: ${event.weather.temperature}°C
      - Cảm giác như: ${event.weather.feelsLike}°C
      - Độ ẩm: ${event.weather.humidity}%
      - Tốc độ gió: ${event.weather.windSpeed} m/s
      - Mô tả thời tiết: ${event.weather.description}
      Hãy trả về các giá trị min_energy, max_energy, target_energy, min_valence, target_valence dưới dạng JSON.
    ''';

      // Gọi API Gemini với prompt
      final geminiResponse = await gemini.text(prompt).catchError((e) {
        emit(MusicError('Lỗi khi gọi Gemini: $e'));
        return null; // Hoặc một giá trị mặc định nào đó
      });

      if (geminiResponse != null) {
        // Kiểm tra và in ra phản hồi
        // print("Gemini Response: ${geminiResponse.output}");

        // Lấy dữ liệu từ phản hồi
        final String responseText = geminiResponse.output ?? '';
        final Map<String, dynamic> responseData =
            parseGeminiResponse(responseText);

        // Kiểm tra và lấy các giá trị từ responseData
        final double minEnergy = responseData['min_energy'] ?? 0.0;
        final double maxEnergy = responseData['max_energy'] ?? 1.0;
        final double targetEnergy = responseData['target_energy'] ?? 0.5;
        final double minValence = responseData['min_valence'] ?? 0.0;
        final double targetValence = responseData['target_valence'] ?? 0.5;

        // Gọi API Spotify để lấy danh sách nhạc
        final recommendations = await musicRepository.getRecommendations(
          minEnergy: minEnergy,
          maxEnergy: maxEnergy,
          targetEnergy: targetEnergy,
          minValence: minValence,
          targetValence: targetValence,
          genres: ['pop'], // Thay thế bằng genres phù hợp nếu cần
        );

        // Emit trạng thái phù hợp
        if (recommendations.isNotEmpty) {
          emit(MusicLoaded(recommendations));
        } else {
          emit(const MusicError('Không tìm thấy bài hát phù hợp'));
        }
      } else {
        emit(const MusicError(
            'Không tìm thấy nhạc cho điều kiện thời tiết này'));
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

Map<String, dynamic> parseGeminiResponse(String geminiResponse) {
  // Logic để phân tích phản hồi từ Gemini, ví dụ:
  try {
    // Xóa các ký tự không cần thiết từ phản hồi
    String cleanedResponse =
        geminiResponse.replaceAll(RegExp(r'(```|json|\s)'), '');
    return jsonDecode(cleanedResponse);
  } catch (e) {
    print('Lỗi khi phân tích phản hồi: $e');
    return {};
  }
}
