import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_search_app/features/github_search/data/datasources/github_remote_data_source.dart';
import 'package:git_search_app/features/github_search/data/repositories/github_repository_impl.dart';
import 'package:git_search_app/features/github_search/domain/usecases/search_repositories.dart';
import 'package:git_search_app/features/github_search/presentation/bloc/github_search_bloc.dart';
import 'package:git_search_app/features/github_search/presentation/pages/search_page.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GitHub Search',

      // Theme configuration
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Add light theme specific styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(color: Colors.white70),
        ),
      ),

      themeMode: ThemeMode.system,

      home: BlocProvider(
        create: (context) => GithubSearchBloc(
          searchRepositories: SearchRepositories(
            GithubRepositoryImpl(
              remoteDataSource: GithubRemoteDataSourceImpl(
                client: http.Client(),
              ),
            ),
          ),
        ),
        child: const SearchPage(),
      ),
    );
  }
}
