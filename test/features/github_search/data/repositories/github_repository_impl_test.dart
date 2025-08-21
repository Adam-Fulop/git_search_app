import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/data/repositories/github_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  late GithubRepositoryImpl repository;
  late MockGithubRemoteDataSource mockRemoteDataSource;
  late DateTime currentTime;
  late List<DateTime> timeStamps;

  setUp(() {
    mockRemoteDataSource = MockGithubRemoteDataSource();
    currentTime = DateTime.now();
    timeStamps = [currentTime];

    repository = GithubRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      getCurrentTime: () => timeStamps.last,
    );
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

  group('Caching behavior', () {
    test('should return cached result within cache duration', () async {
      final response = SearchResponseModel(totalCount: 1, items: []);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      // First call - should call API
      final firstResult = await repository.searchRepositories('test');
      verify(() => mockRemoteDataSource.searchRepositories('test')).called(1);
      expect(firstResult, equals(response));

      // Reset call count
      reset(mockRemoteDataSource);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      // Second call immediately after - should use cache, not call API
      final secondResult = await repository.searchRepositories('test');
      verifyNever(() => mockRemoteDataSource.searchRepositories(any()));
      expect(secondResult, equals(response));
    });

    test('should make new API call after cache expires', () async {
      final response = SearchResponseModel(totalCount: 1, items: []);
      final newResponse = SearchResponseModel(totalCount: 2, items: []);

      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      // First call - should call API
      final firstResult = await repository.searchRepositories('test');
      verify(() => mockRemoteDataSource.searchRepositories('test')).called(1);
      expect(firstResult, equals(response));

      // Move time forward by 3 minutes
      timeStamps.add(currentTime.add(const Duration(minutes: 3)));

      // Reset mock for new response
      reset(mockRemoteDataSource);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => newResponse);

      // Second call after cache expires - should call API again
      final secondResult = await repository.searchRepositories('test');
      verify(() => mockRemoteDataSource.searchRepositories('test')).called(1);
      expect(secondResult, equals(newResponse));
    });

    test('should use cache before cache expires', () async {
      final response = SearchResponseModel(totalCount: 1, items: []);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      // First call - should call API
      final firstResult = await repository.searchRepositories('test');
      verify(() => mockRemoteDataSource.searchRepositories('test')).called(1);
      expect(firstResult, equals(response));

      // Move time forward by 1 minute (still within cache duration)
      timeStamps.add(currentTime.add(const Duration(minutes: 1)));

      // Reset call count
      reset(mockRemoteDataSource);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      // Second call - should use cache, not call API
      final secondResult = await repository.searchRepositories('test');
      verifyNever(() => mockRemoteDataSource.searchRepositories(any()));
      expect(secondResult, equals(response));
    });

    test('should cache different queries separately', () async {
      final response1 = SearchResponseModel(totalCount: 1, items: []);
      final response2 = SearchResponseModel(totalCount: 2, items: []);

      when(
        () => mockRemoteDataSource.searchRepositories('query1'),
      ).thenAnswer((_) async => response1);
      when(
        () => mockRemoteDataSource.searchRepositories('query2'),
      ).thenAnswer((_) async => response2);

      // Call both queries
      final result1 = await repository.searchRepositories('query1');
      final result2 = await repository.searchRepositories('query2');

      verify(() => mockRemoteDataSource.searchRepositories('query1')).called(1);
      verify(() => mockRemoteDataSource.searchRepositories('query2')).called(1);

      // Reset mocks
      reset(mockRemoteDataSource);
      when(
        () => mockRemoteDataSource.searchRepositories(any()),
      ).thenThrow(Exception('Should not be called'));

      // Both queries should be cached separately
      final cachedResult1 = await repository.searchRepositories('query1');
      final cachedResult2 = await repository.searchRepositories('query2');

      expect(cachedResult1, equals(result1));
      expect(cachedResult2, equals(result2));
    });
  });
}
