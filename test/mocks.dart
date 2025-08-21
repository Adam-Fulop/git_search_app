import 'package:mocktail/mocktail.dart';
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/domain/repositories/github_repository.dart';

class MockGithubRepository extends Mock implements GithubRepository {}

class MockGithubRemoteDataSource extends Mock
    implements GithubRemoteDataSource {}
