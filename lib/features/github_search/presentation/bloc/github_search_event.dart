part of 'github_search_bloc.dart';

abstract class GithubSearchEvent {
  const GithubSearchEvent();

  List<Object> get props => [];
}

class SearchRepositoriesEvent extends GithubSearchEvent {
  final String query;

  const SearchRepositoriesEvent(this.query);

  @override
  List<Object> get props => [query];
}
