// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SuggestedTracksWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> tracksList;

  const SuggestedTracksWidget({required this.tracksList});

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
            color: Colors.black,
            height: 240, // Fixed height for the track list
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  color: const Color.fromARGB(255, 41, 41, 41),
                  child: Row(
                    children: [
                      // Track image
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
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
                                child: const Icon(Icons.broken_image,
                                    size: 50, color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                artists.isNotEmpty
                                    ? artists[0]['name'] ?? 'Unknown Artist'
                                    : 'Unknown Artist',
                                style: const TextStyle(color: Colors.white70),
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
