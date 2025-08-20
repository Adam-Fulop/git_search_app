import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/repository.dart';
import '../../../../core/utils/input_converter.dart';

class RepositoryDetailPage extends StatelessWidget {
  final Repository repository;

  const RepositoryDetailPage({super.key, required this.repository});

  Future<void> _launchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputConverter = InputConverter();

    return Scaffold(
      appBar: AppBar(title: Text(repository.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Owner Section
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(repository.ownerAvatarUrl),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repository.ownerLogin,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () =>
                            _launchUrl(repository.ownerHtmlUrl, context),
                        child: Text(
                          'View Profile',
                          style: TextStyle(color: Colors.blue[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Project Info
              Text(
                repository.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (repository.description.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repository.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Repository Link
              GestureDetector(
                onTap: () => _launchUrl(repository.htmlUrl, context),
                child: Text(
                  repository.htmlUrl,
                  style: TextStyle(color: Colors.blue[600]),
                ),
              ),
              const SizedBox(height: 24),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Forks',
                    repository.forksCount.toString(),
                    context,
                  ),
                  _buildStatItem(
                    'Created',
                    inputConverter.formatDate(repository.createdAt),
                    context,
                  ),
                  _buildStatItem(
                    'Updated',
                    inputConverter.formatDate(repository.updatedAt),
                    context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
