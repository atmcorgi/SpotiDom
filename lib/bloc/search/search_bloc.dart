import 'package:SpotiDom/bloc/search/search_event.dart';
import 'package:SpotiDom/bloc/search/search_state.dart';
import 'package:SpotiDom/data/datasources/spotify_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SpotifyApi _spotifyApi;

  SearchBloc(this._spotifyApi) : super(SearchInitial()) {
    on<PerformSearch>((event, emit) async {
      try {
        emit(SearchLoading());
        final results = await _spotifyApi.search(event.query, event.type);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError('Failed to search: $e'));
      }
    });
  }
}
