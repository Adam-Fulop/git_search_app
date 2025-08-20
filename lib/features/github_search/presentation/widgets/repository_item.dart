import 'package:flutter/material.dart';
import 'package:git_search_app/core/utils/input_converter.dart';
import 'package:git_search_app/features/github_search/domain/entities/repository.dart';

class RepositoryItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryItem({
    super.key,
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inputConverter = InputConverter();

    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        onTap: onTap,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repository.ownerLogin,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            if (repository.description.isNotEmpty)
              Text(
                repository.description.length > 100
                    ? '${repository.description.substring(0, 100)}...'
                    : repository.description,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 14.0,
                ),
              ),
            const SizedBox(height: 8.0),
            Text(
              'Last updated: ${inputConverter.formatDateTime(repository.updatedAt)}',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
