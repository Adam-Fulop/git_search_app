import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/usecases/search_repositories.dart';

part 'github_search_event.dart';
part 'github_search_state.dart';

class GithubSearchBloc extends Bloc<GithubSearchEvent, GithubSearchState> {
  final SearchRepositories searchRepositories;

  GithubSearchBloc({required this.searchRepositories})
    : super(GithubSearchInitial()) {
    on<SearchRepositoriesEvent>(_onSearchRepositories);
  }

  FutureOr<void> _onSearchRepositories(
    SearchRepositoriesEvent event,
    Emitter<GithubSearchState> emit,
  ) async {
    emit(GithubSearchLoading());

    try {
      final result = await searchRepositories(event.query);
      emit(GithubSearchSuccess(result: result));
    } on Failure catch (failure) {
      emit(GithubSearchError(message: failure.msg));
    } catch (e) {
      emit(GithubSearchError(message: e.toString()));
    }
  }
}
