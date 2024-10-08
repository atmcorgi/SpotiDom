import 'package:SpotiDom/bloc/control_panel/control_panel_bloc.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/music/music_bloc.dart';
import 'package:SpotiDom/bloc/music/music_event.dart';
import 'package:SpotiDom/bloc/music/music_state.dart';
import 'package:SpotiDom/data/models/weather.dart';
import 'package:SpotiDom/data/repositories/music_repository.dart';

class SuggestMusicSystem extends StatefulWidget {
  final Weather weather;

  const SuggestMusicSystem({super.key, required this.weather});

  @override
  State<SuggestMusicSystem> createState() => _SuggestMusicSystemState();
}

class _SuggestMusicSystemState extends State<SuggestMusicSystem> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicBloc(
        RepositoryProvider.of<MusicRepository>(context),
      )..add(FetchMusicByWeather(widget.weather)),
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MusicLoaded) {
            final tracks = state.tracks;

            // Filter out tracks that have null or empty required information
            final filteredTracks = tracks.where((track) {
              final trackName = track['name'];
              final artistList = track['artists'] as List?;
              final imageUrl = track['album']['images']?.isNotEmpty == true
                  ? track['album']['images'][0]['url']
                  : null;

              return trackName != null &&
                  artistList != null &&
                  imageUrl != null &&
                  artistList.isNotEmpty;
            }).toList();

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                childAspectRatio: 1.0, // Set to 1.0 for square items
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0, // Space between rows
              ),
              itemCount: filteredTracks.length,
              itemBuilder: (context, index) {
                final track = filteredTracks[index];
                final trackName = track['name'] as String? ?? 'Unknown Track';
                final artistList = track['artists'] as List?;
                final artistName = artistList != null && artistList.isNotEmpty
                    ? artistList.map((artist) => artist['name']).join(', ')
                    : 'Unknown Artist';
                final imageUrl = track['album']['images']?.isNotEmpty == true
                    ? track['album']['images'][0]['url']
                    : null;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: GestureDetector(
                    onTap: () {
                      // context.read<MusicBloc>().add(PlayTrack(track['uri']));
                      context.read<ControlPanelBloc>().add(
                            PlayTrackInControlPanel(
                              trackUri: track['uri'],
                              trackName: trackName,
                              artistName: artistName,
                              albumImageUrl: imageUrl,
                            ),
                          );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 180, // Fixed height for uniformity
                      decoration: BoxDecoration(
                        color: _hoveredIndex == index
                            ? Colors.grey.withOpacity(0.2) // Color when hovered
                            : Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: _hoveredIndex == index
                            ? Border.all(
                                color: Colors.white70, // Outline when hovered
                                width: 2,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center items vertically
                        children: [
                          // Album image with rounded corners
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl ?? '',
                              width: 80, // Fixed width
                              height: 80, // Fixed height for square
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  width: 80, // Fixed width
                                  height: 80, // Fixed height for square
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Track info
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0), // Symmetrical padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trackName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  artistName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is MusicError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
