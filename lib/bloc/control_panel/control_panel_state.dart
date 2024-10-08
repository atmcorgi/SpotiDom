class ControlPanelState {
  final String? trackUri;
  final String? trackName;
  final String? artistName;
  final String? albumImageUrl;
  final bool isPlaying;

  ControlPanelState({
    this.trackUri,
    this.trackName,
    this.artistName,
    this.albumImageUrl,
    this.isPlaying = false,
  });

  ControlPanelState copyWith({
    String? trackUri,
    String? trackName,
    String? artistName,
    String? albumImageUrl,
    bool? isPlaying,
  }) {
    return ControlPanelState(
      trackUri: trackUri ?? this.trackUri,
      trackName: trackName ?? this.trackName,
      artistName: artistName ?? this.artistName,
      albumImageUrl: albumImageUrl ?? this.albumImageUrl,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
