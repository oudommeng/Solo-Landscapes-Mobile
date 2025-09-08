import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/components/custom_app_bar.dart';
import 'package:sololandscapes_moblie/components/upcoming_tours_list.dart';
import 'package:sololandscapes_moblie/services/api_config.dart';

// Main widget for the home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State to keep track of the selected tab in the bottom navigation bar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a light grey background color for the entire screen
      backgroundColor: getColorFromHex("F1F1F1"),
      appBar: const CustomAppBar(
        onNotificationPressed: null, // Will use default behavior
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildFindTourSection(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSectionHeader(title: 'Upcoming Tour'),
            ),
            const SizedBox(height: 8),
            Query(
              options: QueryOptions(
                document: gql(ApiConfig.getComingToursQuery),
                variables: {'page': 1},
              ),
              builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text('Error: ${result.exception.toString()}');
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final toursData =
                    result.data?['upcoming_tours'] as List<dynamic>? ?? [];
                final tours = toursData.map((tour) {
                  // Handle gallery - could be array, JSON string, or single string
                  String imageUrl = '';
                  if (tour['gallery'] != null) {
                    try {
                      if (tour['gallery'] is List &&
                          (tour['gallery'] as List).isNotEmpty) {
                        // Handle as actual List
                        final firstImage = (tour['gallery'] as List).first;
                        if (firstImage != null &&
                            firstImage.toString().isNotEmpty) {
                          imageUrl = firstImage.toString();
                        }
                      } else if (tour['gallery'] is String) {
                        final galleryString = tour['gallery'] as String;
                        if (galleryString.isNotEmpty) {
                          // Try to parse as JSON array
                          if (galleryString.startsWith('[') &&
                              galleryString.endsWith(']')) {
                            // Parse JSON string array
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
                            // Handle as single URL string
                            imageUrl = galleryString;
                          }
                        }
                      }
                    } catch (e) {
                      print(
                        'Error processing gallery for ${tour['title']}: $e',
                      );
                    }
                  }

                  // Debug logging
                  print('=== Processing tour: ${tour['title']} ===');
                  print('Raw gallery data: ${tour['gallery']}');
                  print('Gallery type: ${tour['gallery']?.runtimeType}');
                  if (tour['gallery'] is List) {
                    print(
                      'Gallery length: ${(tour['gallery'] as List).length}',
                    );
                    if ((tour['gallery'] as List).isNotEmpty) {
                      print(
                        'First gallery item: ${(tour['gallery'] as List).first}',
                      );
                      print(
                        'First gallery item type: ${(tour['gallery'] as List).first?.runtimeType}',
                      );
                    }
                  }
                  print('Final imageUrl: "$imageUrl"');
                  print('ImageUrl length: ${imageUrl.length}');
                  print('====================================');

                  return {
                    'image': imageUrl,
                    'title': tour['title']?.toString() ?? '',
                    'price': tour['price']?.toString() ?? '0',
                    'startDate': tour['startDate']?.toString() ?? '',
                    'endDate': tour['endDate']?.toString() ?? '',
                    'isEveryday': tour['isEveryday']?.toString() ?? 'false',
                    'rating': '4.9', // Dummy rating
                    'reviews': '56 Reviews', // Dummy reviews
                  };
                }).toList();

                return UpcomingToursList(tours: tours);
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSectionHeader(title: 'Travel Styles'),
            ),
            const SizedBox(height: 16),
            _buildTravelStylesList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds the "Find Your Tour" section with input fields and a search button
  Widget _buildFindTourSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find Your Tour',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7C59), // Muted green color
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(icon: Icons.person_outline, hintText: 'Anywhere'),
        const SizedBox(height: 16),
        _buildTextField(
          icon: Icons.calendar_today_outlined,
          hintText: 'SUN 7-Sep',
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text(
              'Search Your Tour',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF6B8E23), // Olive green color
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget to create a styled text field
  Widget _buildTextField({required IconData icon, required String hintText}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }

  /// Builds the section header with a title and a "See all" button
  Widget _buildSectionHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7C59),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// Builds the horizontal list of "Travel Styles" cards
  Widget _buildTravelStylesList() {
    // Dummy data for travel styles
    final styles = [
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Solo',
      },
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Family',
      },
      {
        'image':
            'https://backend.sololandscapes.co/public/uploads/images/thumbnail-e8ece21a-5871-4e3f-9148-96d8762d5635.jpg',
        'label': 'Group',
      },
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          print(
            'Loading travel style image for ${style['label']}: ${style['image']}',
          );
          return Card(
            elevation: 2,
            shadowColor: Colors.grey.withOpacity(0.2),
            clipBehavior:
                Clip.antiAlias, // Ensures the image respects the border radius
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: [
                  Image.network(
                    style['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('Travel style image load error: $error');
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      print(
                        'Travel style image loading progress: ${loadingProgress.cumulativeBytesLoaded} / ${loadingProgress.expectedTotalBytes}',
                      );
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      style['label']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Experiences',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.style_outlined),
              label: 'Travel Styles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: 'Challenges',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF4A7C59),
          unselectedItemColor: Colors.grey[400],
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // Ensures all labels are visible
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
    );
  }
}
