import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';

abstract class GithubRepository {
  Future<SearchResponseModel> searchRepositories(String query);
}
