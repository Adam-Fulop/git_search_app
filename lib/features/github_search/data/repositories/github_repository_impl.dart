import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/repositories/github_repository.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remoteDataSource;
  final Map<String, ({DateTime timestamp, SearchResponseModel response})>
  _searchCache;
  final Duration cacheDuration;
  final DateTime Function() _getCurrentTime;

  GithubRepositoryImpl({
    required this.remoteDataSource,
    this.cacheDuration = const Duration(minutes: 2),
    DateTime Function()? getCurrentTime,
  }) : _searchCache = {},
       _getCurrentTime = getCurrentTime ?? (() => DateTime.now());

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
      _searchCache[query] = (timestamp: _getCurrentTime(), response: response);

      return response;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  void _cleanCache() {
    final now = _getCurrentTime();
    _searchCache.removeWhere(
      (key, value) => now.difference(value.timestamp) > cacheDuration,
    );
  }
}
