import 'package:git_search_app/features/github_search/domain/entities/repository.dart';

class RepositoryModel {
  final int id;
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final int forksCount;
  final String ownerLogin;
  final String ownerAvatarUrl;
  final String ownerHtmlUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RepositoryModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.forksCount,
    required this.ownerLogin,
    required this.ownerAvatarUrl,
    required this.ownerHtmlUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'] ?? '',
      htmlUrl: json['html_url'] ?? '',
      forksCount: json['forks_count'] ?? 0,
      ownerLogin: json['owner']['login'] ?? '',
      ownerAvatarUrl: json['owner']['avatar_url'] ?? '',
      ownerHtmlUrl: json['owner']['html_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'html_url': htmlUrl,
      'forks_count': forksCount,
      'owner': {
        'login': ownerLogin,
        'avatar_url': ownerAvatarUrl,
        'html_url': ownerHtmlUrl,
      },
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Repository toEntity() {
    return Repository(
      id: id,
      name: name,
      fullName: fullName,
      description: description,
      htmlUrl: htmlUrl,
      forksCount: forksCount,
      ownerLogin: ownerLogin,
      ownerAvatarUrl: ownerAvatarUrl,
      ownerHtmlUrl: ownerHtmlUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
