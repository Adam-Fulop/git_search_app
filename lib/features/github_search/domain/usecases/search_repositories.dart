import 'package:git_search_app/core/usecases/usecases.dart';
import 'package:git_search_app/features/github_search/data/models/search_response_model.dart';
import 'package:git_search_app/features/github_search/domain/repositories/github_repository.dart';

class SearchRepositories implements UseCase<SearchResponseModel, String> {
  final GithubRepository repository;

  SearchRepositories(this.repository);

  @override
  Future<SearchResponseModel> call(String query) async {
    return await repository.searchRepositories(query);
  }
}
