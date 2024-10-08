// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:SpotiDom/bloc/control_panel/control_panel_bloc.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_event.dart';
import 'package:SpotiDom/bloc/search/search_bloc.dart';
import 'package:SpotiDom/bloc/search/search_event.dart';
import 'package:SpotiDom/bloc/search/search_state.dart';
import 'package:SpotiDom/widgets/control_panel.dart';
import 'package:SpotiDom/widgets/footer_widget.dart';
import 'package:SpotiDom/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String searchType = 'track'; // Default search type

  // Update the selected button's style based on current searchType
  ButtonStyle _getButtonStyle(String type) {
    return ElevatedButton.styleFrom(
      backgroundColor: searchType == type ? Colors.green : Colors.grey[800],
      foregroundColor: Colors.white, // Text color (this replaces onPrimary)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: Header(),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: 'Enter a song, artist, album...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        final query = _controller.text.trim();
                        if (query.isNotEmpty) {
                          context.read<SearchBloc>().add(
                                PerformSearch(query: query, type: searchType),
                              );
                          _controller.clear();
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              // Buttons for search type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: _getButtonStyle('track'),
                      onPressed: () {
                        setState(() {
                          searchType = 'track';
                        });
                      },
                      child: const Text('Track'),
                    ),
                    ElevatedButton(
                      style: _getButtonStyle('artist'),
                      onPressed: () {
                        setState(() {
                          searchType = 'artist';
                        });
                      },
                      child: const Text('Artist'),
                    ),
                    ElevatedButton(
                      style: _getButtonStyle('album'),
                      onPressed: () {
                        setState(() {
                          searchType = 'album';
                        });
                      },
                      child: const Text('Album'),
                    ),
                    ElevatedButton(
                      style: _getButtonStyle('playlist'),
                      onPressed: () {
                        setState(() {
                          searchType = 'playlist';
                        });
                      },
                      child: const Text('Playlist'),
                    ),
                  ],
                ),
              ),

              // Search Results List
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoaded) {
                      return ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          final item = state.results[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            leading: item['album'] != null &&
                                    item['album']['images'].isNotEmpty
                                ? Image.network(
                                    item['album']['images'][0]['url'],
                                    height: 50,
                                    width: 50)
                                : const Icon(Icons.music_note,
                                    color: Colors.white, size: 50),
                            title: Text(
                              item['name'] ?? 'Unknown Name',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              item['artists'] != null &&
                                      item['artists'].isNotEmpty
                                  ? item['artists'][0]['name']
                                  : 'Unknown Artist',
                              style: const TextStyle(color: Colors.white54),
                            ),
                            trailing: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onTap: () {
                              // Lấy thông tin cần thiết từ item
                              final trackUri = item['uri'];
                              final trackName = item['name'] ?? 'Unknown Name';
                              final artistName = item['artists'] != null &&
                                      item['artists'].isNotEmpty
                                  ? item['artists'][0]['name']
                                  : 'Unknown Artist';
                              final imageUrl = item['album'] != null &&
                                      item['album']['images'].isNotEmpty
                                  ? item['album']['images'][0]['url']
                                  : '';

                              // Gọi sự kiện PlayTrack để phát nhạc
                              // context
                              //     .read<MusicBloc>()
                              //     .add(PlayTrack(trackUri));
                              context.read<ControlPanelBloc>().add(
                                    PlayTrackInControlPanel(
                                      trackUri: trackUri,
                                      trackName: trackName,
                                      artistName: artistName,
                                      albumImageUrl: imageUrl,
                                    ),
                                  );
                            },
                          );
                        },
                      );
                    } else if (state is SearchError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)));
                    } else {
                      return const Center(
                          child: Text('Start searching for tracks...',
                              style: TextStyle(color: Colors.white)));
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: ControlPanelWidget()),
        ],
      ),
      bottomNavigationBar: Footer(), // Footer vẫn ở vị trí cuối cùng
    );
  }
}
