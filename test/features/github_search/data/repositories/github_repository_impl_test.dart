import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/data/repositories/github_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  late GithubRepositoryImpl repository;
  late MockGithubRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockGithubRemoteDataSource();
    repository = GithubRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  test('should return data when remote call is successful', () async {
    final response = SearchResponseModel(totalCount: 1, items: []);

    when(
      () => mockRemoteDataSource.searchRepositories(any()),
    ).thenAnswer((_) async => response);

    final result = await repository.searchRepositories('test');

    verify(() => mockRemoteDataSource.searchRepositories('test')).called(1);
    expect(result, equals(response));
  });

  test('should propagate failure when remote call fails', () async {
    when(
      () => mockRemoteDataSource.searchRepositories(any()),
    ).thenThrow(ServerFailure('Server error'));

    expect(
      () => repository.searchRepositories('test'),
      throwsA(isA<ServerFailure>()),
    );
  });

  test('should propagate NetworkFailure when remote call fails', () async {
    when(
      () => mockRemoteDataSource.searchRepositories(any()),
    ).thenThrow(NetworkFailure('Network error'));

    expect(
      () => repository.searchRepositories('test'),
      throwsA(isA<NetworkFailure>()),
    );
  });

  test('should convert unexpected exceptions to ServerFailure', () async {
    when(
      () => mockRemoteDataSource.searchRepositories(any()),
    ).thenThrow(Exception('Unexpected error'));

    expect(
      () => repository.searchRepositories('test'),
      throwsA(isA<ServerFailure>()),
    );
  });
}
