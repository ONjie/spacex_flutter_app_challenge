// A custom exception class to represent GraphQL-related errors.
class GraphQLException implements Exception {
  final String message;
  GraphQLException({required this.message});
}

