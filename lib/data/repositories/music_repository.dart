import 'package:SpotiDom/data/datasources/spotify_api.dart';

class MusicRepository {
  final SpotifyApi spotifyApi;

  MusicRepository(this.spotifyApi);

  // Phương thức nhận các tham số dựa trên thời tiết và trả về danh sách nhạc
  Future<List<Map<String, dynamic>>> getRecommendations({
    required double minEnergy,
    required double maxEnergy,
    required double targetEnergy,
    required double minValence,
    required double targetValence,
    required List<String> genres,
  }) {
    // Gọi phương thức từ SpotifyApi với các tham số
    return spotifyApi.getRecommendations(
      minEnergy: minEnergy,
      maxEnergy: maxEnergy,
      targetEnergy: targetEnergy,
      minValence: minValence,
      targetValence: targetValence,
      genres: genres,
    );
  }

  Future<void> playTrack({required String trackUri}) {
    // Gọi phương thức từ SpotifyApi với các tham số
    return spotifyApi.playTrack(trackUri: trackUri);
  }
}
