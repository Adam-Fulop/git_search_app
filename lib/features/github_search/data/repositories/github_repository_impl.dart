import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/repositories/github_repository.dart';

class GithubRepositoryImpl implements GithubRepository {
  GithubRepositoryImpl({required this.remoteDataSource});

  final GithubRemoteDataSource remoteDataSource;

  final Map<String, ({DateTime timestamp, SearchResponseModel response})>
  _searchCache = {};
  final Duration _cacheDuration = const Duration(minutes: 2);

  @override
  Future<SearchResponseModel> searchRepositories(String query) async {
    try {
      // Clean old cache entries
      _cleanCache();

      // Check cache
      final cached = _searchCache[query];
      if (cached != null) {
        return cached.response;
      }

      // Fetch from API
      final response = await remoteDataSource.searchRepositories(query);

      // Update cache
      _searchCache[query] = (timestamp: DateTime.now(), response: response);

      return response;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  void _cleanCache() {
    final now = DateTime.now();
    _searchCache.removeWhere(
      (key, value) => now.difference(value.timestamp) > _cacheDuration,
    );
  }
}
