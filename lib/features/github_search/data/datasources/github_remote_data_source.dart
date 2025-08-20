import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:git_search_app/core/errors/failures.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';

abstract class GithubRemoteDataSource {
  Future<SearchResponseModel> searchRepositories(String query);
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final http.Client client;

  GithubRemoteDataSourceImpl({required this.client});

  @override
  Future<SearchResponseModel> searchRepositories(String query) async {
    try {
      final encodedQuery = Uri.encodeQueryComponent(query);
      final url = Uri.parse(
        'https://api.github.com/search/repositories?q=$encodedQuery',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SearchResponseModel.fromJson(jsonResponse);
      } else {
        throw ServerFailure(
          'Failed to search repositories: ${response.statusCode}',
        );
      }
    } on http.ClientException {
      throw NetworkFailure('Network error occurred');
    } catch (e) {
      throw ServerFailure('An error occurred: $e');
    }
  }
}
