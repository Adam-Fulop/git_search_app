class Repository {
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

  const Repository({
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
}
