import 'package:flutter/material.dart';
import 'package:weather_music_app/services/spotify_service.dart';

class ControlPanel extends StatefulWidget {
  final SpotifyService spotifyService;

  ControlPanel({Key? key, required this.spotifyService}) : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  bool isPlaying = false;
  String currentTrackTitle = '';
  String currentTrackArtist = '';
  String currentTrackImageUrl = '';

  @override
  void initState() {
    super.initState();
    _updateCurrentTrack();
  }

  Future<void> _updateCurrentTrack() async {
    final trackInfo = await widget.spotifyService.getCurrentlyPlayingTrack();
    setState(() {
      currentTrackTitle = trackInfo?['item']['name'];
      currentTrackArtist = trackInfo?['item']['artists'][0]['name'];
      currentTrackImageUrl = trackInfo?['item']['album']['images'][0]['url'];
      isPlaying = trackInfo?['is_playing'];
    });
  }

  Future<void> _play() async {
    final trackInfo = await widget.spotifyService.getCurrentlyPlayingTrack();

    if (trackInfo != null) {
      int positionMs = trackInfo['progress_ms'] ?? 0;
      int position =
          trackInfo['item'] != null && trackInfo['item']['track_number'] != null
              ? trackInfo['item']['track_number'] - 1
              : 0;

      if (trackInfo['context'] != null && trackInfo['context']['uri'] != null) {
        await widget.spotifyService.startOrResumePlayback(
            trackInfo['context']['uri'], position,
            positionMs: positionMs);
      } else {
        String context = 'spotify:album:${trackInfo['item']['album']['id']}';
        // print(context);
        await widget.spotifyService
            .startOrResumePlayback(context, position, positionMs: positionMs);
      }
      // Cập nhật trạng thái isPlaying
      setState(() {
        currentTrackTitle = trackInfo['item']['name'];
        currentTrackArtist = trackInfo['item']['artists'][0]['name'];
        currentTrackImageUrl = trackInfo['item']['album']['images'][0]['url'];
        isPlaying = true;
      });
    } else {
      print("Không có track đang được phát.");
    }
  }

  Future<void> _pause() async {
    final playbackState = await widget.spotifyService.getPlaybackState();
    if (playbackState != null && playbackState['is_playing']) {
      await widget.spotifyService.pausePlayback();
    } else {
      print("Không có nội dung nào đang phát để tạm dừng.");
    }
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _next() async {
    await widget.spotifyService.skipToNext();
    // _updateCurrentTrack();
  }

  Future<void> _previous() async {
    await widget.spotifyService.skipToPrevious();
    // _updateCurrentTrack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.blueGrey.withOpacity(.8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Album cover
              ClipOval(
                child: Image.network(
                  currentTrackImageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey,
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.white),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentTrackTitle.isNotEmpty
                          ? currentTrackTitle
                          : 'Loading...',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentTrackArtist.isNotEmpty ? currentTrackArtist : '',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Colors.white, size: 24),
                    onPressed: _previous,
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: isPlaying ? _pause : _play,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 24),
                    onPressed: _next,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
