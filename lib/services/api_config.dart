class ApiConfig {
  static const String graphqlEndpoint =
      'https://backend.sololandscapes.co/graphql';

  static const String getComingToursQuery = r'''
    query GetComingTours($page: Int) {
      upcoming_tours(page: $page) {
        id
        title
        startDate
        endDate
        upcoming
        description
        information
        price
        createdBy
        gallery
        createdAt
        updatedAt
        message
        status
        total
        discount
        isEveryday
        createdBy
        experiences {
          title
          id
        }
        category {
          id
          title
        }
        destination {
          id
          title
        }
      }
    }
  ''';
}
