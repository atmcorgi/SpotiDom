# PKA - Group 5 - SpotiDom

Ứng dụng Flutter giúp gợi ý và phát nhạc dựa trên điều kiện thời tiết hiện tại. Ứng dụng tích hợp với OpenWeather API để lấy dữ liệu thời tiết và Spotify Web API để gợi ý và điều khiển phát nhạc.

## Tính Năng

- Lấy thông tin thời tiết theo thời gian thực dựa trên vị trí hiện tại hoặc thành phố người dùng chọn.
- Gợi ý nhạc dựa trên thời tiết hiện tại.
- Tích hợp với Spotify Web API để phát nhạc.
- Điều khiển phát nhạc đầy đủ (phát, tạm dừng, chuyển bài tiếp theo, quay lại bài trước, xáo trộn, v.v.).
- Hiển thị thông tin thời tiết và nhạc trên màn hình chính.

## Công Nghệ Sử Dụng

- **Flutter**: Xây dựng ứng dụng di động đa nền tảng.
- **Spotify Web API**: Để lấy gợi ý nhạc và điều khiển phát nhạc.
- **OpenWeather API**: Để lấy dữ liệu thời tiết hiện tại.
- **BLoC (Business Logic Component)**: Quản lý trạng thái trong Flutter. (hoặc Provider vì hiện tại chưa làm)

## Màn Hình Chính

1. **Màn Hình Chính**:

   - Hiển thị điều kiện thời tiết hiện tại.
   - Danh sách các thành phố để người dùng chọn.
   - Gợi ý nhạc dựa trên thời tiết.
   - Các danh sách nhạc phổ biến, các bài hát theo tâm trạng.
   - Bao gồm các nút điều khiển phát nhạc (phát, tạm dừng, chuyển bài).

2. **Tìm Kiếm**:

   - Cho phép người dùng tìm kiếm nhạc thủ công.

3. **Thư Viện**:

   - Hiển thị các playlist và bài hát đã lưu.

4. **Hồ Sơ**:
   - Hiển thị hồ sơ Spotify và thói quen nghe nhạc của người dùng.

## Cài Đặt

### Yêu Cầu

Trước khi bắt đầu, hãy đảm bảo bạn đã đáp ứng các yêu cầu sau:

- Bạn đã cài đặt Flutter SDK: [Bắt Đầu Với Flutter](https://docs.flutter.dev/get-started/install).
- Bạn có tài khoản Spotify Developer: [Spotify Developer](https://developer.spotify.com/dashboard/).
- Bạn có khóa API của OpenWeather: [OpenWeather API](https://openweathermap.org/api).

### Thiết Lập

1. Clone dự án:

   ```bash
   git clone https://github.com/atmcorgi/SpotiDom.git
   cd SpotiDom
   ```

2. Cài đặt các thư viện phụ thuộc:

   ```bash
   flutter pub get
   ```

3. Thiết lập các biến môi trường cho khóa API trong file `.env`:

   ```env
   SPOTIFY_CLIENT_ID=your_spotify_client_id
   SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
   OPENWEATHER_API_KEY=your_openweather_api_key
   ```

4. Chạy ứng dụng:

   ```bash
   flutter run
   ```
