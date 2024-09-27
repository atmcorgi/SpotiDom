import 'package:flutter/material.dart';

class PopularTracksWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> popularTracks;

  PopularTracksWidget({
    required this.popularTracks,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: popularTracks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No saved tracks available'));
        }

        final tracks = snapshot.data!.take(3).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            final songTitle = track['name'] ?? 'Unknown Song';
            final artistName =
                track['artists']?.first['name'] ?? 'Unknown Artist';
            final imageUrl = track['album']['images'][0]['url'] ?? '';

            return _buildTrackTile(
              songTitle: songTitle,
              artistName: artistName,
              imageUrl: imageUrl,
            );
          },
        );
      },
    );
  }

  Widget _buildTrackTile({
    required String songTitle,
    required String artistName,
    required String imageUrl,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: Icon(Icons.broken_image, size: 50, color: Colors.white),
            );
          },
        ),
      ),
      title: Text(
        songTitle,
        style: TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        artistName,
        style: TextStyle(fontSize: 12, color: Colors.white70),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: () {
          // Handle more options
        },
      ),
    );
  }
}
