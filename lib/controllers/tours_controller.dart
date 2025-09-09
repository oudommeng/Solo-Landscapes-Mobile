import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sololandscapes_moblie/services/api_config.dart';

enum SortBy { price, date, rating, name }

enum FilterBy { all, solo, family, group }

class ToursController extends GetxController {
  // Observable variables
  final RxList<Map<String, dynamic>> allTours = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredTours =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortBy> currentSort = SortBy.date.obs;
  final Rx<FilterBy> currentFilter = FilterBy.all.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  // GraphQL client (you'll need to inject this or get it from your app)
  GraphQLClient? _graphQLClient;

  @override
  void onInit() {
    super.onInit();
    // Don't load tours immediately during onInit to avoid build conflicts
    // Will be loaded manually after widget is built

    // Listen to search changes with debounce
    debounce(
      searchQuery,
      (_) => _filterAndSortTours(),
      time: const Duration(milliseconds: 500),
    );
  }

  void setGraphQLClient(GraphQLClient client) {
    _graphQLClient = client;
  }

  Future<void> loadTours({bool loadMore = false}) async {
    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      currentPage.value = 1;
      allTours.clear();
    }

    try {
      if (_graphQLClient == null) {
        throw Exception('GraphQL client not initialized');
      }

      final QueryResult result = await _graphQLClient!.query(
        QueryOptions(
          document: gql(ApiConfig.getComingToursQuery),
          variables: {'page': currentPage.value},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final toursData = result.data?['upcoming_tours'] as List<dynamic>? ?? [];

      if (toursData.isEmpty) {
        hasMoreData.value = false;
      } else {
        final newTours = toursData
            .map((tour) => _processTourData(tour))
            .toList();

        if (loadMore) {
          allTours.addAll(newTours);
        } else {
          allTours.assignAll(newTours);
        }

        currentPage.value++;
      }

      _filterAndSortTours();
    } catch (e) {
      print('Error loading tours: ${e.toString()}');
      // Don't show snackbar during initialization
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Map<String, dynamic> _processTourData(Map<String, dynamic> tour) {
    // Process gallery images
    String imageUrl = '';
    if (tour['gallery'] != null) {
      try {
        if (tour['gallery'] is List && (tour['gallery'] as List).isNotEmpty) {
          final firstImage = (tour['gallery'] as List).first;
          if (firstImage != null && firstImage.toString().isNotEmpty) {
            imageUrl = firstImage.toString();
          }
        } else if (tour['gallery'] is String) {
          final galleryString = tour['gallery'] as String;
          if (galleryString.isNotEmpty) {
            if (galleryString.startsWith('[') && galleryString.endsWith(']')) {
              final cleanedString = galleryString.substring(
                1,
                galleryString.length - 1,
              );
              final urls = cleanedString
                  .split('","')
                  .map((url) => url.replaceAll('"', '').trim())
                  .where((url) => url.isNotEmpty)
                  .toList();
              if (urls.isNotEmpty) {
                imageUrl = urls.first;
              }
            } else {
              imageUrl = galleryString;
            }
          }
        }
      } catch (e) {
        print('Error processing gallery for ${tour['title']}: $e');
      }
    }

    return {
      'id': tour['id']?.toString() ?? '',
      'image': imageUrl,
      'title': tour['title']?.toString() ?? '',
      'description': tour['description']?.toString() ?? '',
      'information': tour['information']?.toString() ?? '',
      'price': double.tryParse(tour['price']?.toString() ?? '0') ?? 0.0,
      'startDate': tour['startDate']?.toString() ?? '',
      'endDate': tour['endDate']?.toString() ?? '',
      'upcoming': tour['upcoming'] ?? false,
      'isEveryday': tour['isEveryday']?.toString() == 'true',
      'createdBy': tour['createdBy']?.toString() ?? '',
      'gallery': tour['gallery']?.toString() ?? '',
      'createdAt': tour['createdAt']?.toString() ?? '',
      'updatedAt': tour['updatedAt']?.toString() ?? '',
      'message': tour['message']?.toString() ?? '',
      'status': tour['status']?.toString() ?? '',
      'discount': double.tryParse(tour['discount']?.toString() ?? '0') ?? 0.0,
      'rule_images': tour['rule_images']?.toString() ?? '',
      'experiences': tour['experiences'] ?? [],
      'category': tour['category']?['title']?.toString() ?? 'all',
      'categoryId': tour['category']?['id']?.toString() ?? '',
      'destination': tour['destination']?['title']?.toString() ?? '',
      'destinationId': tour['destination']?['id']?.toString() ?? '',
      'rating': 4.9, // Dummy rating
      'reviews': 56, // Dummy reviews
    };
  }

  void searchTours(String query) {
    searchQuery.value = query;
  }

  void sortTours(SortBy sortBy) {
    currentSort.value = sortBy;
    _filterAndSortTours();
  }

  void filterTours(FilterBy filterBy) {
    currentFilter.value = filterBy;
    _filterAndSortTours();
  }

  void _filterAndSortTours() {
    List<Map<String, dynamic>> filtered = List.from(allTours);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((tour) {
        return tour['title'].toString().toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        );
      }).toList();
    }

    // Apply category filter
    if (currentFilter.value != FilterBy.all) {
      filtered = filtered.where((tour) {
        return tour['category'].toString().toLowerCase() ==
            currentFilter.value.name;
      }).toList();
    }

    // Apply sorting
    switch (currentSort.value) {
      case SortBy.price:
        filtered.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double),
        );
        break;
      case SortBy.date:
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a['startDate']) ?? DateTime.now();
          final dateB = DateTime.tryParse(b['startDate']) ?? DateTime.now();
          return dateA.compareTo(dateB);
        });
        break;
      case SortBy.rating:
        filtered.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
        );
        break;
      case SortBy.name:
        filtered.sort(
          (a, b) => a['title'].toString().compareTo(b['title'].toString()),
        );
        break;
    }

    filteredTours.assignAll(filtered);
  }

  void loadMoreTours() {
    if (!isLoadingMore.value && hasMoreData.value) {
      loadTours(loadMore: true);
    }
  }

  void refreshTours() {
    hasMoreData.value = true;
    loadTours();
  }
}
