import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String accessToken;

  SpotifyService(this.accessToken);

  Future<List<Map<String, dynamic>>> fetchRecommendations() async {
    String seedArtists = '06HL4z0CvFAxyc27GXpf02';
    String seedGenres = 'pop';
    String seedTracks = '3CeCwYWvdfXbZLXFhBrbnf';

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/recommendations?seed_artists=$seedArtists&seed_genres=$seedGenres&seed_tracks=$seedTracks&limit=6'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, dynamic>> recommendations =
          List<Map<String, dynamic>>.from(data['tracks']);
      return recommendations;
    } else {
      print('Lỗi khi gọi API: ${response.statusCode}');
      print('Chi tiết lỗi: ${response.body}');
      throw Exception('Failed to load recommendations');
    }
  }

  Future<Map<String, dynamic>> getTrack(String trackId) async {
    print(trackId);
    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/tracks/$trackId'), // Note the endpoint
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Return the single track object
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load track');
    }
  }

  Future<List<Map<String, dynamic>>> getSeveralTracks(
      List<String> trackIds) async {
    final ids = trackIds.join(',');
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks?ids=$ids'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['tracks']);
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load tracks');
    }
  }

  Future<Map<String, dynamic>?> getPlaybackState() async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/player'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error getting playback state: ${response.statusCode}');
      return null;
    }
  }

  // Phương thức phát nhạc
  Future<void> playTrack(String trackUri) async {
    // Macbook
    final deviceId = '1ed2a2afb27326f10b6ff0c6538c3a15ba1439d0';

    // Iphone
    // final deviceId = '4e8466bbe469af939d4bf35071726222c15be4ee';

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

  // Phương thức bỏ qua bài hát
  Future<void> skipToNext() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/next');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      print(
          'Error skipping to next track: ${response.statusCode} ${response.body}');
    }
  }

  // Phương thức quay lại bài hát trước
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
    }
  }

  // Phương thức tạm dừng phát nhạc
  Future<void> pausePlayback() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/pause');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      print('Error pausing playback: ${response.statusCode} ${response.body}');
    }
  }

  // Get Currently Playing Track
  Future<Map<String, dynamic>?> getCurrentlyPlayingTrack() async {
    final url =
        Uri.parse('https://api.spotify.com/v1/me/player/currently-playing');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null; // No track is currently playing
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

  // Get Recently Played Tracks
  Future<List<dynamic>> getRecentlyPlayedTracks() async {
    final url =
        Uri.parse('https://api.spotify.com/v1/me/player/recently-played');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to get recently played tracks: ${response.body}');
    }
  }

  // Get the User's Queue
  Future<List<dynamic>> getUserQueue() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/player/queue');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['queue'];
    } else {
      throw Exception('Failed to get user queue: ${response.body}');
    }
  }

  // Add Item to Playback Queue
  Future<void> addItemToQueue(String trackUri) async {
    final url =
        Uri.parse('https://api.spotify.com/v1/me/player/queue?uri=$trackUri');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to add item to queue: ${response.body}');
    }
  }
}
