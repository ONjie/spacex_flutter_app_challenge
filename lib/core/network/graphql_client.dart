import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static const String _endpoint = 'https://spacex-production.up.railway.app/';

  static HttpLink _httpLink = HttpLink(_endpoint);

  static GraphQLClient _client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  static GraphQLClient get client => _client;

  static ValueNotifier<GraphQLClient> get clientNotifier =>
      ValueNotifier(_client);

  static void clearCache() {
    _client.cache.store.reset();
  }

  static void updateEndpoint(String newEndpoint) {
    _httpLink = HttpLink(newEndpoint);
    _client = GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
