import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/usecases/search_repositories.dart';
import 'package:git_search_app/features/github_search/presentation/bloc/github_search_bloc.dart';

class MockSearchRepositories extends Mock implements SearchRepositories {}

void main() {
  late GithubSearchBloc bloc;
  late MockSearchRepositories mockSearchRepositories;

  setUp(() {
    mockSearchRepositories = MockSearchRepositories();
    bloc = GithubSearchBloc(searchRepositories: mockSearchRepositories);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is GithubSearchInitial', () {
    expect(bloc.state, isA<GithubSearchInitial>());
  });

  blocTest<GithubSearchBloc, GithubSearchState>(
    'emits [GithubSearchLoading, GithubSearchSuccess] when search is successful',
    build: () {
      when(
        () => mockSearchRepositories(any()),
      ).thenAnswer((_) async => SearchResponseModel(totalCount: 1, items: []));
      return bloc;
    },
    act: (bloc) => bloc.add(SearchRepositoriesEvent('test')),
    expect: () => [isA<GithubSearchLoading>(), isA<GithubSearchSuccess>()],
  );

  blocTest<GithubSearchBloc, GithubSearchState>(
    'emits [GithubSearchLoading, GithubSearchError] when search fails',
    build: () {
      when(
        () => mockSearchRepositories(any()),
      ).thenThrow(ServerFailure('Error message'));
      return bloc;
    },
    act: (bloc) => bloc.add(SearchRepositoriesEvent('test')),
    expect: () => [isA<GithubSearchLoading>(), isA<GithubSearchError>()],
  );
}
