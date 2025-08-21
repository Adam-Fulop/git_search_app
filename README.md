# GitHub search application

Mobile app for searching GitHub repositories.

## About this project

The application is built on the GitHub Search API. Based on the search criteria specified in the search field, it lists the first 30 relevant results, depending on the sorting criteria.
From the results list, a detailed page about the repository can then be displayed with additional information:
- owner name, avatar and link to GitHub profile
- project name
- description + GitHub repository link
- number of forks
- creation time
- last update time

### Examples of searches:
- <code>highway language:Dart created:>2025-01-17</code>
- <code>language:Dart state:open sort:stars-desc</code>