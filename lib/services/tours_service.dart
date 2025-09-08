import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sololandscapes_moblie/services/api_config.dart';

class ToursService {
  static final ToursService _instance = ToursService._internal();
  factory ToursService() => _instance;
  ToursService._internal();

  Future<QueryResult> fetchUpcomingTours(
    GraphQLClient client, {
    int page = 1,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(ApiConfig.getComingToursQuery),
      variables: {'page': page},
    );
    return await client.query(options);
  }
}
