abstract class SearchEvent {}

class PerformSearch extends SearchEvent {
  final String query;
  final String type;

  PerformSearch({required this.query, required this.type});
}
