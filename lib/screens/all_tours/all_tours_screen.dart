import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sololandscapes_moblie/controllers/tours_controller.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/unit/font.dart';

class AllToursScreen extends StatefulWidget {
  const AllToursScreen({super.key});

  @override
  State<AllToursScreen> createState() => _AllToursScreenState();
}

class _AllToursScreenState extends State<AllToursScreen> {
  @override
  void initState() {
    super.initState();
    // Load tours after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ToursController>();
      // Get GraphQL client from arguments
      final arguments = Get.arguments as Map<String, dynamic>?;
      final GraphQLClient? client = arguments?['client'] as GraphQLClient?;

      // Initialize controller with GraphQL client
      if (client != null) {
        controller.setGraphQLClient(client);
        controller.loadTours();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ToursController controller = Get.find<ToursController>();

    return Scaffold(
      backgroundColor: ColorsHex("F1F1F1"),
      appBar: const CustomAppBar(
        onNotificationPressed: null,
        showBackButton: true,
        useUserService: false,
        userName: 'All Tours',
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredTours.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredTours.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async => controller.refreshTours(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMoreTours();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount:
                        controller.filteredTours.length +
                        (controller.isLoadingMore.value ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.filteredTours.length) {
                        return _buildLoadingCard();
                      }
                      return _buildTourCard(controller.filteredTours[index]);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(ToursController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: (value) => controller.searchTours(value),
            decoration: InputDecoration(
              hintText: 'Search tours...',
              hintStyle: KantumruyFont.regular(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              filled: true,
              fillColor: ColorsHex("F1F1F1"),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter and Sort buttons
          Row(
            children: [
              Expanded(child: _buildFilterButton(controller)),
              const SizedBox(width: 12),
              Expanded(child: _buildSortButton(controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ToursController controller) {
    return Obx(
      () => OutlinedButton.icon(
        onPressed: () => _showFilterBottomSheet(controller),
        icon: const Icon(Icons.filter_list),
        label: Text(
          'Filter: ${controller.currentFilter.value.name.capitalizeFirst}',
          style: KantumruyFont.medium(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: primary600,
          side: BorderSide(color: primary600),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildSortButton(ToursController controller) {
    return Obx(
      () => OutlinedButton.icon(
        onPressed: () => _showSortBottomSheet(controller),
        icon: const Icon(Icons.sort),
        label: Text(
          'Sort: ${_getSortDisplayName(controller.currentSort.value)}',
          style: KantumruyFont.medium(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: primary600,
          side: BorderSide(color: primary600),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  String _getSortDisplayName(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.price:
        return 'Price';
      case SortBy.date:
        return 'Date';
      case SortBy.rating:
        return 'Rating';
      case SortBy.name:
        return 'Name';
    }
  }

  Widget _buildTourCard(Map<String, dynamic> tour) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withValues(alpha: 0.1),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to tour details
          Get.toNamed('/tour-details', arguments: tour);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    tour['image'].toString().isNotEmpty
                        ? Image.network(
                            tour['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[600],
                                  ),
                                ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 8,
                            ),
                            color: Colors.white.withValues(alpha: 0.1),
                            child: Text(
                              tour['destination'] ?? 'Unknown Location',
                              style: KantumruyFont.medium(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tour details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour['title'],
                      style: KantumruyFont.bold(
                        fontSize: 14,
                        color: primary600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '\$${tour['price'].toStringAsFixed(0)} per person',
                      style: KantumruyFont.bold(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tours found',
            style: KantumruyFont.bold(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: KantumruyFont.regular(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(ToursController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Tours',
              style: KantumruyFont.bold(fontSize: 18, color: primary600),
            ),
            const SizedBox(height: 20),
            ...FilterBy.values.map(
              (filter) => Obx(
                () => RadioListTile<FilterBy>(
                  title: Text(
                    filter.name.capitalizeFirst ?? '',
                    style: KantumruyFont.medium(),
                  ),
                  value: filter,
                  groupValue: controller.currentFilter.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.filterTours(value);
                      Get.back();
                    }
                  },
                  activeColor: primary600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(ToursController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Tours',
              style: KantumruyFont.bold(fontSize: 18, color: primary600),
            ),
            const SizedBox(height: 20),
            ...SortBy.values.map(
              (sort) => Obx(
                () => RadioListTile<SortBy>(
                  title: Text(
                    _getSortDisplayName(sort),
                    style: KantumruyFont.medium(),
                  ),
                  value: sort,
                  groupValue: controller.currentSort.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.sortTours(value);
                      Get.back();
                    }
                  },
                  activeColor: primary600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
