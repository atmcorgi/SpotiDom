import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String accessToken;
  final String _baseUrl = 'https://api.spotify.com/v1/recommendations';

  SpotifyApi(this.accessToken);

  // Phương thức nhận các tham số để tạo request đến API Spotify
  Future<List<Map<String, dynamic>>> getRecommendations({
    required double minEnergy,
    required double maxEnergy,
    required double targetEnergy,
    required double minValence,
    required double targetValence,
    required List<String> genres,
  }) async {
    final String genreSeed = genres.map(Uri.encodeComponent).join(',');

    // Tạo query parameters
    final Map<String, String> queryParameters = {
      'seed_genres': genreSeed,
      'min_energy': minEnergy.toString(),
      'max_energy': maxEnergy.toString(),
      'target_energy': targetEnergy.toString(),
      'min_valence': minValence.toString(),
      'target_valence': targetValence.toString(),
      'limit': '20', // Giới hạn số bài hát trả về
    };

    final uri = Uri.parse(
        '$_baseUrl?${queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}');

    // Gửi yêu cầu GET đến Spotify API
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['tracks'] as List)
          .map((track) => track as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception(
          'Failed to fetch recommendations: ${response.statusCode}');
    }
  }

// Phương thức phát nhạc
  Future<void> playTrack({required String trackUri}) async {
    const deviceId = '1ed2a2afb27326f10b6ff0c6538c3a15ba1439d0';

    final url = Uri.parse(
        'https://api.spotify.com/v1/me/player/play?device_id=$deviceId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uris': [trackUri],
      }),
    );

    if (response.statusCode != 204) {
      print('Error playing track: ${response.statusCode} ${response.body}');
      throw Exception('Failed to play track');
    }
  }
}
