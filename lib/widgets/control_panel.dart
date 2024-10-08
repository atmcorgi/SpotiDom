// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_bloc.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_state.dart';
import 'package:SpotiDom/bloc/control_panel/control_panel_event.dart';

class ControlPanelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlPanelBloc, ControlPanelState>(
      builder: (context, state) {
        if (state.trackUri == null) {
          return const SizedBox.shrink();
        }
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.only(
                left: 16.0, right: 8.0, top: 8.0, bottom: 0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(29, 185, 84, 0.95), // Spotify green
                  Color.fromARGB(255, 12, 12, 12), // Black color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Album cover image
                    if (state.albumImageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          state.albumImageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),

                    // Song and artist information
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.trackName ?? 'Unknown Track',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              state.artistName ?? 'Unknown Artist',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Control buttons (Previous, Play/Pause, Next)
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        context.read<ControlPanelBloc>().add(PreviousTrack());
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        state.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        if (state.isPlaying) {
                          context.read<ControlPanelBloc>().add(PauseTrack());
                        } else {
                          context.read<ControlPanelBloc>().add(ResumeTrack());
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        context.read<ControlPanelBloc>().add(NextTrack());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
