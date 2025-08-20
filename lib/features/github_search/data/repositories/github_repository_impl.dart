import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/repositories/github_repository.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remoteDataSource;

  GithubRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SearchResponseModel> searchRepositories(String query) async {
    try {
      final response = await remoteDataSource.searchRepositories(query);
      return response;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
