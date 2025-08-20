import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_search_app/core/utils/keyboard_utils.dart';
import 'package:git_search_app/features/github_search/domain/entities/repository.dart';
import 'package:git_search_app/features/github_search/presentation/pages/repository_detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/data/repositories/github_repository_impl.dart';
import 'package:git_search_app/features/github_search/domain/usecases/search_repositories.dart';
import '../bloc/github_search_bloc.dart';
import '../widgets/search_field.dart';
import '../widgets/repository_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final GithubSearchBloc _searchBloc = GithubSearchBloc(
    searchRepositories: SearchRepositories(
      GithubRepositoryImpl(
        remoteDataSource: GithubRemoteDataSourceImpl(client: http.Client()),
      ),
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.close();
    super.dispose();
  }

  void _searchRepositories() {
    KeyboardUtils.dismissKeyboard(context);
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _searchBloc.add(SearchRepositoriesEvent(query));
    }
  }

  void _navigateToDetail(BuildContext context, Repository repository) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryDetailPage(repository: repository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Search')),
      body: BlocConsumer<GithubSearchBloc, GithubSearchState>(
        bloc: _searchBloc,
        listener: (context, state) {
          if (state is GithubSearchLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => _alertDialog(),
            );
          } else if (state is GithubSearchSuccess ||
              state is GithubSearchError) {
            Navigator.of(context).pop();
          }

          if (state is GithubSearchError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchField(
                  controller: _searchController,
                  onSearch: _searchRepositories,
                  hintText: 'Enter your search criteria here',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _searchRepositories,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.blueGrey
                          : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 20),
                        SizedBox(width: 8),
                        Text('Search', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildResults(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  AlertDialog _alertDialog() {
    return AlertDialog(
      title: const Text('Searching GitHub'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          CircularProgressIndicator(),
          Text('Please wait...'),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildResults(GithubSearchState state) {
    if (state is GithubSearchInitial) {
      return Center(
        child: Text(
          'Enter search criteria to begin',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      );
    } else if (state is GithubSearchSuccess) {
      final repositories = state.result.items;
      final totalCount = state.result.totalCount;

      if (repositories.isEmpty) {
        return Center(
          child: Text(
            'No repositories found',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        );
      }

      return Column(
        children: [
          // Results limit warning
          if (totalCount > 30)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.orange[50]
                    : null,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Showing 30 of $totalCount results. Please narrow down your search criteria for better results.',
                      style: TextStyle(color: Colors.orange[800], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          // Results count
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Found ${repositories.length} result${repositories.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),

          // Results list
          Expanded(
            child: ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repository = repositories[index].toEntity();
                return RepositoryItem(
                  repository: repository,
                  onTap: () => _navigateToDetail(context, repository),
                );
              },
            ),
          ),
        ],
      );
    } else if (state is GithubSearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
