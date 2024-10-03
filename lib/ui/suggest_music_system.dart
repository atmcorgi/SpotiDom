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
      )..add(FetchMusicByWeather(widget.weather.description)),
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MusicLoaded) {
            final tracks = state.tracks;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                final trackName = track['name'] as String? ?? 'Unknown Track';
                final artistList = track['artists'] as List?;
                final artistName = artistList != null && artistList.isNotEmpty
                    ? artistList.map((artist) => artist['name']).join(', ')
                    : 'Unknown Artist';
                final imageUrl = track['album']['images']?.isNotEmpty == true
                    ? track['album']['images'][0]['url']
                    : null;

                // Tạo hiệu ứng hover
                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: GestureDetector(
                    onTap: () {
                      print("Play song with URI: ${track['uri']}");
                      context.read<MusicBloc>().add(PlayTrack(track['uri']));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // Màu nền mặc định khi không hover
                        color: _hoveredIndex == index
                            ? Colors.grey.withOpacity(0.2) // Màu nền khi hover
                            : Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: _hoveredIndex == index
                            ? Border.all(
                                color: Colors.white70, // Outline khi hover
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Hình ảnh album với hiệu ứng bo tròn
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Thông tin bài hát
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trackName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  artistName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Icon phát nhạc
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              print("Play song with URI: ${track['uri']}");
                            },
                          ),
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
