import 'package:equatable/equatable.dart';

abstract class ControlPanelEvent extends Equatable {
  const ControlPanelEvent();

  @override
  List<Object?> get props => [];
}

class PlayTrackInControlPanel extends ControlPanelEvent {
  final String trackUri;
  final String trackName;
  final String artistName;
  final String albumImageUrl; // Add albumImageUrl field

  const PlayTrackInControlPanel({
    required this.trackUri,
    required this.trackName,
    required this.artistName,
    required this.albumImageUrl, // Initialize in constructor
  });

  @override
  List<Object?> get props =>
      [trackUri, trackName, artistName, albumImageUrl]; // Include in props
}

class PauseTrack extends ControlPanelEvent {}

class ResumeTrack extends ControlPanelEvent {}

class StopTrack extends ControlPanelEvent {}

class PreviousTrack extends ControlPanelEvent {}

class NextTrack extends ControlPanelEvent {}
