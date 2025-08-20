part of 'github_search_bloc.dart';

abstract class GithubSearchState {
  const GithubSearchState();
}

class GithubSearchInitial extends GithubSearchState {}

class GithubSearchLoading extends GithubSearchState {}

class GithubSearchSuccess extends GithubSearchState {
  final SearchResponseModel result;

  const GithubSearchSuccess({required this.result});
}

class GithubSearchError extends GithubSearchState {
  final String message;

  const GithubSearchError({required this.message});
}
