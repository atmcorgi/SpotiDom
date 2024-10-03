import 'package:flutter/material.dart';
import 'package:SpotiDom/services/spotify_service.dart';

class MusicByMoodWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> tracksList;
  final SpotifyService spotifyService; // Tham số cho SpotifyService

  MusicByMoodWidget({
    required this.tracksList,
    required this.spotifyService, // Nhận SpotifyService
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tracksList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tracks available'));
        } else {
          final data = snapshot.data!;
          return Container(
            height: 220,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1 / 0.8,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final track = data[index];
                final songTitle = track['name'] ?? 'Unknown Song';
                final trackUri = track['uri']; // Lấy URI bài hát

                return GestureDetector(
                  onTap: () {
                    spotifyService.playTrack(trackUri);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            track['album']['images'] != null &&
                                    track['album']['images'].isNotEmpty
                                ? track['album']['images'][0]['url']
                                : '',
                            fit: BoxFit.cover,
                            width: 180,
                            height: 180,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 180,
                                height: 180,
                                color: Colors.grey,
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.white),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              songTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
