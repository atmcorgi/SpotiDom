import 'package:equatable/equatable.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object> get props => [];
}

// Trạng thái khi nhạc đang được tải
class MusicLoading extends MusicState {}

// Trạng thái khi nhạc đã được tải thành công
class MusicLoaded extends MusicState {
  final List<Map<String, dynamic>> tracks; // Lưu thông tin của nhiều bài hát

  const MusicLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

// Trạng thái khi có lỗi xảy ra
class MusicError extends MusicState {
  final String message;

  const MusicError(this.message);

  @override
  List<Object> get props => [message];
}

class MusicPlaying extends MusicState {
  final String trackUri;

  MusicPlaying(this.trackUri);

  @override
  List<Object> get props => [trackUri];
}
