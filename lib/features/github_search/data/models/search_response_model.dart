import 'package:git_search_app/features/github_search/data/models/repository_model.dart';

class SearchResponseModel {
  final int totalCount;
  final List<RepositoryModel> items;

  const SearchResponseModel({required this.totalCount, required this.items});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      totalCount: json['total_count'] ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => RepositoryModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
