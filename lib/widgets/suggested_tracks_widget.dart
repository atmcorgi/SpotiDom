import 'package:flutter/material.dart';

class SuggestedTracksWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> tracksList;

  SuggestedTracksWidget({required this.tracksList});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tracksList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tracks available'));
        } else {
          final data = snapshot.data!;

          return Container(
            color: Colors.black,
            height: 240, // Fixed height for the track list
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 3 / 1, // Fixed height ratio
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final track = data[index];
                final artists = track['artists'] ?? [];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Color.fromARGB(255, 41, 41, 41),
                  child: Row(
                    children: [
                      // Track image
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                          child: Image.network(
                            track['album']['images'] != null &&
                                    track['album']['images'].isNotEmpty
                                ? track['album']['images'][0]['url']
                                : '', // Default image if not available
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
                      ),
                      SizedBox(width: 8),
                      // Track and artist names
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track['name'] ?? 'Unknown Track',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                artists.isNotEmpty
                                    ? artists[0]['name'] ?? 'Unknown Artist'
                                    : 'Unknown Artist',
                                style: TextStyle(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
