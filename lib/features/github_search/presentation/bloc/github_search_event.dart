part of 'github_search_bloc.dart';

abstract class GithubSearchEvent {
  const GithubSearchEvent();
}

class SearchRepositoriesEvent extends GithubSearchEvent {
  final String query;

  const SearchRepositoriesEvent(this.query);
}
