// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String accessToken;
  final String _baseUrl = 'https://api.spotify.com/v1/recommendations';

  SpotifyApi(this.accessToken);

  // Phương thức lấy gợi ý nhạc
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
      'limit': '51', // Giới hạn số bài hát trả về
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

  // Phương thức tạm dừng phát nhạc
  Future<void> pausePlayback() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/pause');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      print('Error pausing playback: ${response.statusCode} ${response.body}');
      throw Exception('Failed to pause playback');
    }
  }

  // Start/Resume Playback
  Future<void> startOrResumePlayback(String trackUri, int position,
      {int positionMs = 0}) async {
    const deviceId = '1ed2a2afb27326f10b6ff0c6538c3a15ba1439d0';
    final url = Uri.parse(
        'https://api.spotify.com/v1/me/player/play?device_id=$deviceId');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'context_uri': trackUri,
          'offset': {'position': position},
          'position_ms': positionMs,
        }));

    if (response.statusCode != 204) {
      throw Exception('Failed to start/resume playback: ${response.body}');
    }
  }

  // Phương thức chuyển đến bài hát tiếp theo
  Future<void> skipToNext() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/next');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode != 204) {
        print(
            'Error skipping to next track: ${response.statusCode} ${response.body}');
        throw Exception('Failed to skip to next track');
      }
    } catch (e) {
      throw Exception('Failed to skip to next: $e');
    }
  }

  // Phương thức quay lại bài hát trước đó
  Future<void> skipToPrevious() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/previous');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      print(
          'Error skipping to previous track: ${response.statusCode} ${response.body}');
      throw Exception('Failed to skip to previous track');
    }
  }

  // Lấy thông tin bài hát hiện tại đang phát
  Future<Map<String, dynamic>?> getCurrentlyPlayingTrack() async {
    final url =
        Uri.parse('https://api.spotify.com/v1/me/player/currently-playing');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 204) {
      // Không có bài hát nào đang phát
      return null;
    } else {
      print(
          'Error getting currently playing track: ${response.statusCode} ${response.body}');
      throw Exception('Failed to get currently playing track');
    }
  }

// Phương thức tìm kiếm nhạc, nghệ sĩ, album, playlist
  Future<List<Map<String, dynamic>>> search(String query, String type) async {
    final url = Uri.parse(
      'https://api.spotify.com/v1/search?q=$query&type=$type&limit=30',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data[type + 's']['items'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      print('Error searching: ${response.statusCode} ${response.body}');
      throw Exception('Failed to search');
    }
  }
}
