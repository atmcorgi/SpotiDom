import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpotifyAuthService {
  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  SpotifyAuthService({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  Future<void> authenticate() async {
    const code =
        'AQB8D0mcCAIPrhAvNco1cOsGbsevcwNiUKFy9WLvS7Foqx5M-_VMV4L7wmTv6tlnBwwsx0h5qaeBaJMikg8M9UyhyT_koVNYGw0NtdR3SfwWMyZ5KETCQj412dvegvzZUiRcXHXxHhiNoAoT78eIbyO6-bzRGOSFobRuDXLQ8JRr1gCjXZkjrRlQ0b8T3mLawkH4NyT98q4p68CoUpFxh2tGZcZ3pvxzBFUIz4uYyHsJy1H2kZP-lOFNBcBl4tnajMxZhDIcDzI0pxl711hdTsGTXzPmsFCn_0nThxghHuAxZtEOYJnDLUmre4yUOCihSc8x9eJLYI7zrc1qqXzWUPjeoTIpJsTMDQzDn41vlYEnteJEQoBDb0YP4rMEntYpsjXsQMNHQN6rsu6StlExYaXEFnxjqUqLpc-Z6g';
    await _exchangeCodeForToken(code);
  }

  // Bước 2: Đổi mã ủy quyền lấy access và refresh token
  Future<void> _exchangeCodeForToken(String code) async {
    final url = Uri.parse('https://accounts.spotify.com/api/token');

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await secureStorage.write(
          key: 'access_token', value: data['access_token']);
      await secureStorage.write(
          key: 'refresh_token', value: data['refresh_token']);
      // print('Access token: ${data['access_token']}');
    } else {
      print('Lỗi đổi mã ủy quyền: ${response.statusCode} ${response.body}');
      throw Exception('Lỗi đổi mã ủy quyền');
    }
  }

  // Bước 3: Lấy access token từ storage
  Future<String?> getAccessToken() async {
    String? accessToken = await secureStorage.read(key: 'access_token');

    // Kiểm tra xem access token có tồn tại không
    if (accessToken == null) {
      await authenticate();
      accessToken = await secureStorage.read(key: 'access_token');
    }

    return accessToken;
  }

  // Bước 4: Refresh access token khi hết hạn
  Future<void> refreshAccessToken() async {
    final refreshToken = await secureStorage.read(key: 'refresh_token');

    if (refreshToken == null) {
      throw Exception('Không có refresh token để làm mới access token');
    }

    final url = Uri.parse('https://accounts.spotify.com/api/token');

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await secureStorage.write(
          key: 'access_token', value: data['access_token']);
      // Có thể cập nhật refresh_token nếu được cung cấp
      if (data['refresh_token'] != null) {
        await secureStorage.write(
            key: 'refresh_token', value: data['refresh_token']);
      }
    } else {
      print(
          'Lỗi làm mới access token: ${response.statusCode} ${response.body}');
      throw Exception('Lỗi làm mới access token');
    }
  }
}
