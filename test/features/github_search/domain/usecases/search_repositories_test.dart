import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/usecases/search_repositories.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  late SearchRepositories useCase;
  late MockGithubRepository mockRepository;

  setUp(() {
    mockRepository = MockGithubRepository();
    useCase = SearchRepositories(mockRepository);
  });

  test(
    'should call repository.searchRepositories with correct query',
    () async {
      const query = 'test query';
      final response = SearchResponseModel(totalCount: 0, items: []);

      when(
        () => mockRepository.searchRepositories(any()),
      ).thenAnswer((_) async => response);

      await useCase(query);

      verify(() => mockRepository.searchRepositories(query)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return the response from repository', () async {
    const query = 'test query';
    final expectedResponse = SearchResponseModel(totalCount: 2, items: []);

    when(
      () => mockRepository.searchRepositories(any()),
    ).thenAnswer((_) async => expectedResponse);

    final result = await useCase(query);

    expect(result, equals(expectedResponse));
    verify(() => mockRepository.searchRepositories(query)).called(1);
  });

  test('should propagate exceptions from repository', () async {
    const query = 'test query';
    final exception = Exception('Repository error');

    when(() => mockRepository.searchRepositories(any())).thenThrow(exception);

    expect(() => useCase(query), throwsA(equals(exception)));
  });
}
